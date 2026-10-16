########################################################################################################################
# Input variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key."
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region of the existing project. Red Hat AI Inference is available in us-east."
  default     = "us-east"
}

variable "existing_project_id" {
  type        = string
  description = "The ID (GUID) or CRN of an existing Red Hat AI Inference project."
}
