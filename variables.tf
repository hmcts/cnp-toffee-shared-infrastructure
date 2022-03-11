
//SHARED VARIABLES
variable "subscription" {}

variable "product" {
  description = "The name of your application"
  default     = "plum"
}

variable "env" {
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "location" {
  description = "The location where you would like to deploy your infrastructure"
  default     = "UK South"
}

//APP INSIGHTS SPECIFIC VARIABLES
variable "appinsights_location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "UK South"
}

variable "application_type" {
  description = "This is the type of application you are creating app insights. Valid values are Web and Other"
  default     = "web"
}

//KEY VAULT SPECIFIC VARIABLES
variable "tenant_id" {
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

variable "team_contact" {
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#Cloud-Native"
}

variable "certificate_name" {
  default     = "STAR-platform-hmcts-net"
  description = "The certificate name to use in public listeners. Should support the public hostname."
}

variable "public_hostname" {
  default     = "plum.platform.hmcts.net"
  description = "The public hostanme to use when accessing plum's frontend"
}

variable "health_check_interval" {
  default     = "60"
  description = "interval between healthchecks in seconds"
}

variable "unhealthy_threshold" {
  default     = "3"
  description = "unhealthy threshold applied to healthprobe"
}

variable "health_check" {
  default     = "/health"
  description = "endpoint for healthcheck"
}


variable "infra_location" {
  default = "core-infra"
}

variable "common_tags" {
  type = map(string)
}

variable "managed_identity_object_id" {
  default = ""
}
variable "developers_group" {
  default = "DTS SDS Developers"
}

variable "servicebus_pe_subnet_ids" {
  default     = ""
  description = "List of subnets that need access to the service bus namespace"
}
