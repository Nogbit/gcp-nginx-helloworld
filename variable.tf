variable "project_id" {
   description = "A valid GCP Project ID.  Try to use firstname-lastname-purpose for example."
   type        = string
}

variable "region" {
   description = "The GCP region where resources will be provisioned, us-west1 for example."
   type        = string
}

variable "zone" {
   description = "The GCP zone where resources will be provisioned, us-west1-a for example."
   type        = string
}

variable "subnet_cidr" {
   description = "The CIDR range to use for your subnet within your VPC"
   type        = string
}