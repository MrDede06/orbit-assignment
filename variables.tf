
variable "resourcegroup_name" {
  type        = string
  description = "The name of the resource group"
  default     = "<resource group name>"
}

variable "location" {
  type        = string
  description = "The region for the deployment"
  default     = "<region>"
}

variable "str_account_name" {
  type        = string
  description = "Storage account name"
  default     = "<storage>"
}

variable "app_service_plan" {
  type        = string
  description = "App service Plan Name"
  default     = "<AppService>"
}

variable "function_app" {
  type        = string
  description = "Function App Name"
  default     = "<AppName>"
}