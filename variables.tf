variable "function_name" {
  description = "Name for the Lambda function and related resources."
  type        = string
  default     = "sample-function-url"
}

variable "environment_variables" {
  description = "Environment variables to inject into the Lambda function."
  type        = map(string)
  default     = {}
}

variable "ssm_function_arn_name" {
  description = "SSM Parameter Store name to save the Lambda function ARN."
  type        = string
  default     = "/sample/function/arn"
}

variable "ssm_function_url_name" {
  description = "SSM Parameter Store name to save the Lambda Function URL."
  type        = string
  default     = "/sample/function/url"
}
