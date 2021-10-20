
variable "AZURE_TENANT_ID" {
  type = string
}

variable "AZURE_SUBSCRIPTION_ID" {
  type = string
}

variable "AZURE_CLIENT_ID" {
  type = string
}

variable "AZURE_CLIENT_SECRET" {
  type      = string
  sensitive = true
}

variable "HCA_COST_ID" {
  type = string
}

variable "HCA_COST_CENTER" {
  type = string
}

variable "HCA_DEPARTMENT_ID" {
  type = string
}

variable "HCA_APP_CODE" {
  type = string
}
