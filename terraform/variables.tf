variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. eg)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "cidr_block" {
  type        = "string"
  description = "Classless Inter-Domain Routing block"
}

# variable "region" {
#   type        = "string"
#   description = "Region for VPC"
# }

locals {
  max_availability_zones = 2
}

variable "jenkins_user" {
  type        = "string"
}

variable "jenkins_password" {
  type        = "string"
}

variable "jenkins_url" {
  type        = "string"
}