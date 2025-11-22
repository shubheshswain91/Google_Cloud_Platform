variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "subnet_1_name" {
  description = "The name of the first subnet."
  type        = string
}

variable "subnet_2_name" {
  description = "The name of the second subnet."
  type        = string
}