# Bootstrap (per-environment Terraform backends)

Provision **per-environment** Terraform backends (S3 state + DynamoDB lock) and the base IAM/OIDC bits from a **single repo**, with one tiny root per environment.

## Folder Structure

```plaintext
infrastructure/bootstrap/
├─ bootstrap.sh                 # one script to init/plan/apply/destroy any env
├─ bootstrap_staging/           # tiny root for the 'staging' env (calls module)
│  ├─ main.tf
│  ├─ variables.tf
│  ├─ providers.tf
│  └─ backend.tf                
└─ bootstrap_production/        
   ├─ main.tf
   ├─ variables.tf
   ├─ providers.tf
   └─ backend.tf
│                 
└─ bootstrap_dev/  etc..
```

Shared variables live up a level:

```plaintext
envs/
├─ common.auto.tfvars.json      # shared defaults (region, project, etc.)
└─ <env>.tfvars.json            # per-env values (aws_account_id, environment, etc.)
```

## How It Works

* Each env has a **tiny root** (`bootstrap_<env>/`) that calls the reusable module and declares `terraform { backend "s3" {} }` **without hard-coded values**.
* The `bootstrap.sh` script:

  1. Loads `envs/common.auto.tfvars.json` and `envs/<env>.tfvars.json`.
  2. Reads `aws_account_id` from `<env>.tfvars.json` and compares it to the current account from `aws sts get-caller-identity`. If they differ → **fail**.
  3. Creates the S3 bucket and DynamoDB lock table if missing.
  4. Runs `terraform init -reconfigure` with the backend values.
  5. Runs `plan`, `apply`, or `destroy` with the correct vars.
* Each env keeps its own `.terraform` cache using `TF_DATA_DIR`.

## Prerequisites

* Terraform ≥ 1.7
* AWS CLI v2
* `jq`
* Valid AWS credentials for the target account
* `envs/<env>.tfvars.json` must include `aws_account_id`


## Usage

Authenticate to the correct account first:

```bash
aws sso login --profile staging
export AWS_PROFILE=staging
```

Or if you are using Access Keys from an IAM User, simply check you are authenticated to the account you which matches your environment:

```bash
aws sts get-caller-identity
```

Expected values are as follows:

```bash
./bootstrap.sh env plan/apply/destroy
```

Examples:

```bash
./bootstrap.sh staging plan
./bootstrap.sh staging apply
./bootstrap.sh staging destroy
```


## Creating a New Environment (e.g., `dev`)

1. Create `envs/dev.tfvars.json`:

```json
{
  "environment": "dev",
  "aws_account_id": "999999999999"
}
```

2. Run:

```bash
./bootstrap.sh dev apply
```

## `bootstrap_<env>/` Structure

## Safety & Conventions

* `aws_account_id` in tfvars must match current creds.
* Use proper GitHub OIDC `trusted_sub` patterns.
* Ignore `.terraform/`, `*.tfstate*`, `*.tfvars*` in Git, but commit `.terraform.lock.hcl`.

## Troubleshooting

* **Account mismatch**: Log in to the correct account.
* **Backend init error**: Run via `bootstrap.sh`.
* **OIDC AccessDenied**: Check issuer, audience, and `sub`.

