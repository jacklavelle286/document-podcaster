#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./bootstrap.sh <env> [plan|apply|destroy] [--force]
#
# Examples:
#   ./bootstrap.sh staging apply
#   ./bootstrap.sh production plan
#   ./bootstrap.sh staging destroy --force   # non-interactive backend deletion
#
# Requires: jq, awscli, terraform
# Assumptions:
#   - This script lives alongside main.tf/variables.tf that call the bootstrap module
#   - Shared vars:   ../../envs/common.auto.tfvars.json
#   - Env vars:      ../../envs/<env>.tfvars.json  (includes aws_account_id)

ENV="${1:-}"
ACTION="${2:-apply}"
FORCE_DELETE="false"

# Parse optional flags
for arg in "${@:3}"; do
  case "$arg" in
    --force|-f) FORCE_DELETE="true" ;;
    *) echo "Unknown option: $arg"; echo "Usage: $0 <env> [plan|apply|destroy] [--force]"; exit 1 ;;
  esac
done

if [[ -z "$ENV" ]]; then
  echo "Usage: $0 <env> [plan|apply|destroy] [--force]"
  exit 1
fi

# Paths (single directory for all envs)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TF_ROOT="$SCRIPT_DIR"  # main.tf lives here now
COMMON_FILE="${SCRIPT_DIR}/../../envs/common.auto.tfvars.json"
ENV_FILE="${SCRIPT_DIR}/../../envs/${ENV}.tfvars.json"

# Dependencies
for bin in jq aws terraform; do
  command -v "$bin" >/dev/null || { echo "Missing dependency: $bin"; exit 1; }
done

[[ -f "$TF_ROOT/main.tf" ]] || { echo "Expected Terraform root at: $TF_ROOT"; exit 1; }
[[ -f "$COMMON_FILE"      ]] || { echo "Missing: $COMMON_FILE"; exit 1; }
[[ -f "$ENV_FILE"         ]] || { echo "Missing: $ENV_FILE"; exit 1; }

# Source-of-truth account ID from env tfvars
EXPECTED_ID="$(jq -r '.aws_account_id // empty' "$ENV_FILE")"
[[ -n "$EXPECTED_ID" ]] || { echo "❌ envs/${ENV}.tfvars.json must include \"aws_account_id\""; exit 1; }

# Actual caller account
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text 2>/dev/null || true)"
[[ -n "$ACCOUNT_ID" && "$ACCOUNT_ID" != "None" ]] || { echo "❌ No AWS creds found. Run 'aws sso login' or set AWS_PROFILE."; exit 1; }
if [[ "$EXPECTED_ID" != "$ACCOUNT_ID" ]]; then
  echo "❌ ERROR: Expected AWS account $EXPECTED_ID for env '$ENV', got $ACCOUNT_ID"
  exit 1
fi

# Vars
REGION="$(jq -r '.region' "$COMMON_FILE")"
PROJECT="$(jq -r '.project' "$COMMON_FILE")"
ENVIRONMENT="$(jq -r '.environment' "$ENV_FILE")"

# Backend names (per env/account)
BUCKET="${ACCOUNT_ID}-${REGION}-${PROJECT}-${ENVIRONMENT}-bootstrap"
DDB="${ACCOUNT_ID}-${REGION}-${PROJECT}-${ENVIRONMENT}-bootstrap-lock"
KEY="terraform.tfstate"

# Merge tags (common + env) and add standard keys
COMMON_EXTRA="$(jq -c '.extra_tags // {}' "$COMMON_FILE")"
ENV_EXTRA="$(jq -c '.extra_tags // {}' "$ENV_FILE")"
MERGED_TAGS_JSON="$(
  jq -n \
     --arg project "$PROJECT" \
     --arg environment "$ENVIRONMENT" \
     --arg region "$REGION" \
     --arg module "bootstrap" \
     --argjson common "$COMMON_EXTRA" \
     --argjson env "$ENV_EXTRA" \
     '
     ($common + $env)
     + {project:$project, environment:$environment, region:$region, module:$module}
     '
)"

json_to_s3_tagset() {
  jq -c 'to_entries | {TagSet: map({Key:.key, Value:(.value|tostring)})}' <<<"$MERGED_TAGS_JSON"
}
json_to_ddb_tags_args() {
  jq -r 'to_entries | map("Key=\(.key),Value=\(.value|tostring)") | .[]' <<<"$MERGED_TAGS_JSON"
}

S3_TAGSET_JSON="$(json_to_s3_tagset)"
DDB_TAGS_ARGS=( $(json_to_ddb_tags_args) )

cat <<INFO
Env:        $ENV
Action:     $ACTION
Account:    $ACCOUNT_ID
Region:     $REGION
Project:    $PROJECT
Bucket:     $BUCKET
DynamoDB:   $DDB
Key:        $KEY
Tags:       $(jq -c <<<"$MERGED_TAGS_JSON")
Force:      $FORCE_DELETE
INFO

# Per-env TF cache dir (avoid plugin/state cache collisions)
export TF_DATA_DIR="${TF_ROOT}/.terraform-${ENV}"

# ---------- Helpers ----------

empty_versioned_bucket() {
  local bucket="$1"
  echo "Emptying versioned S3 bucket: ${bucket}"

  local key_marker=""
  local ver_marker=""
  local is_truncated="true"

  while [[ "$is_truncated" == "true" ]]; do
    local resp
    if [[ -n "$key_marker" && -n "$ver_marker" ]]; then
      resp="$(aws s3api list-object-versions --bucket "$bucket" --key-marker "$key_marker" --version-id-marker "$ver_marker" || true)"
    else
      resp="$(aws s3api list-object-versions --bucket "$bucket" || true)"
    fi

    # If bucket missing/empty
    if [[ -z "$resp" ]]; then
      break
    fi

    local to_delete count
    to_delete="$(jq -c '
      { Objects:
          ([(.Versions // [])[], (.DeleteMarkers // [])[]]
           | map({Key: .Key, VersionId: .VersionId}))
      }' <<<"$resp")"
    count="$(jq '.Objects | length' <<<"$to_delete")"

    if (( count > 0 )); then
      echo "  Deleting ${count} object versions/markers..."
      aws s3api delete-objects --bucket "$bucket" --delete "$to_delete" >/dev/null || true
    fi

    is_truncated="$(jq -r '.IsTruncated // false | tostring' <<<"$resp")"
    if [[ "$is_truncated" == "true" ]]; then
      key_marker="$(jq -r '.NextKeyMarker // empty' <<<"$resp")"
      ver_marker="$(jq -r '.NextVersionIdMarker // empty' <<<"$resp")"
    fi
  done

  # Final sweep for any current objects/non-versioned remnants
  aws s3 rm "s3://${bucket}" --recursive || true
  echo "Bucket emptied: ${bucket}"
}

tag_ddb_table() {
  local table="$1"
  local arn
  arn="$(aws dynamodb describe-table --table-name "$table" --query 'Table.TableArn' --output text 2>/dev/null || true)"
  if [[ -n "$arn" && ${#DDB_TAGS_ARGS[@]} -gt 0 ]]; then
    aws dynamodb tag-resource --resource-arn "$arn" --tags "${DDB_TAGS_ARGS[@]}" || true
  fi
}

# ---------- Ensure backend (ONLY for plan/apply) ----------
if [[ "$ACTION" != "destroy" ]]; then
  # S3
  if ! aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    echo "Creating S3 bucket: $BUCKET"
    if [[ "$REGION" == "us-east-1" ]]; then
      aws s3api create-bucket --bucket "$BUCKET"
    else
      aws s3api create-bucket --bucket "$BUCKET" --create-bucket-configuration "LocationConstraint=${REGION}"
    fi
    aws s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled
    aws s3api put-bucket-encryption --bucket "$BUCKET" \
      --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
    aws s3api put-public-access-block --bucket "$BUCKET" \
      --public-access-block-configuration 'BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true'
  else
    echo "S3 bucket exists: $BUCKET"
  fi
  # Tag S3 (overwrite full TagSet)
  aws s3api put-bucket-tagging --bucket "$BUCKET" --tagging "$S3_TAGSET_JSON"

  # DDB
  if ! aws dynamodb describe-table --table-name "$DDB" >/dev/null 2>&1; then
    echo "Creating DynamoDB table: $DDB"
    aws dynamodb create-table \
      --table-name "$DDB" \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST >/dev/null
    aws dynamodb wait table-exists --table-name "$DDB"
  else
    echo "DynamoDB table exists: $DDB"
  fi
  tag_ddb_table "$DDB"
fi

# ---------- Init backend (works for all actions; on destroy we assume backend exists) ----------
terraform -chdir="$TF_ROOT" init -reconfigure \
  -backend-config="bucket=${BUCKET}" \
  -backend-config="key=${KEY}" \
  -backend-config="region=${REGION}" \
  -backend-config="dynamodb_table=${DDB}" \
  -backend-config="encrypt=true"

# ---------- Terraform action ----------
case "$ACTION" in
  plan)
    terraform -chdir="$TF_ROOT" plan -var-file="$COMMON_FILE" -var-file="$ENV_FILE"
    ;;
  apply)
    terraform -chdir="$TF_ROOT" plan  -var-file="$COMMON_FILE" -var-file="$ENV_FILE"
    terraform -chdir="$TF_ROOT" apply -auto-approve -var-file="$COMMON_FILE" -var-file="$ENV_FILE"
    ;;
  destroy)
    terraform -chdir="$TF_ROOT" destroy -auto-approve -var-file="$COMMON_FILE" -var-file="$ENV_FILE"
    echo
    if [[ "$FORCE_DELETE" == "true" ]]; then
      ANS="y"
    else
      read -p "Also delete backend bucket/table for $ENV? (y/N): " ANS
    fi
    if [[ "$ANS" =~ ^[Yy]$ ]]; then
      echo "Cleaning backend objects..."

      # Empty versioned bucket fully (handles pagination)
      if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
        empty_versioned_bucket "$BUCKET"
        aws s3api delete-bucket --bucket "$BUCKET" || true
      else
        echo "Bucket $BUCKET does not exist."
      fi

      # Delete DDB table and wait until gone
      if aws dynamodb describe-table --table-name "$DDB" >/dev/null 2>&1; then
        aws dynamodb delete-table --table-name "$DDB" || true
        aws dynamodb wait table-not-exists --table-name "$DDB" || true
      else
        echo "DynamoDB table $DDB does not exist."
      fi
      echo "Backend removed."
    else
      echo "Left backend intact (bucket: $BUCKET, table: $DDB)."
    fi
    ;;
  *)
    echo "Unknown action: $ACTION (expected plan|apply|destroy)"; exit 1;;
esac

echo "✅ Done: $ENV $ACTION"
