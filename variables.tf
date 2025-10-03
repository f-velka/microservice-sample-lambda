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
