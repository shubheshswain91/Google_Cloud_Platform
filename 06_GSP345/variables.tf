variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "qwiklabs-gcp-02-4"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-west1-a"
}
