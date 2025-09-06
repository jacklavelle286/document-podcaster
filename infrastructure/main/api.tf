module "api" {
  source = "../modules/api"
  get_job_function_arn = module.get_job_function.function_arn
  uploader_function_arn = module.uploader_function.function_arn
  uploader_function_name = module.uploader_function.function_name
  get_job_function_name = module.get_job_function.function_name
  get_voices_function_arn = module.get_voices_function.function_arn
  get_voices_function_name = module.get_voices_function.function_name
}