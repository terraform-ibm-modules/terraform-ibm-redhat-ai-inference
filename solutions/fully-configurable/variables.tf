########################################################################################################################
# Input variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key that is used to deploy the resources in this solution."
  sensitive   = true
}

variable "provider_visibility" {
  type        = string
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public` and `private`. With `private`, Terraform must run on the IBM Cloud private network, as it does in IBM Cloud Projects and Schematics. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  default     = "private"
  nullable    = false

  validation {
    condition     = contains(["public", "private"], var.provider_visibility)
    error_message = "Invalid value for 'provider_visibility'. Supported values are 'public' and 'private'."
  }
}

variable "prefix" {
  type        = string
  nullable    = true
  default     = null
  description = "The prefix to add to all resources created by this solution. To skip using a prefix, set this value to null or an empty string. The prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It should not exceed 16 characters, must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--'). Example: prod-0205-cos. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z]{0,1}[-a-z0-9]{0,14}[a-z0-9]{0,1}$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter, contain only lowercase letters, digits, and hyphens '-', not exceed 16 characters, not end with a hyphen, and not contain consecutive hyphens."
  }
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision the Red Hat AI Inference (RHAII) project in. Not used when `existing_project_id` is set."
  default     = "Default"
  nullable    = false
}

variable "region" {
  type        = string
  description = "The region where the Red Hat AI Inference (RHAII) project is created. Only `us-east` is supported. [Learn more](https://cloud.ibm.com/docs/inference)."
  default     = "us-east"
  nullable    = false
}

variable "project_name" {
  type        = string
  description = "The name of the Red Hat AI Inference (RHAII) project to create. If a prefix is set, it is added to the front of this name. Not used when `existing_project_id` is set."
  default     = "rhaii"
  nullable    = false
}

variable "existing_project_id" {
  type        = string
  description = "The ID (GUID) or CRN of an existing Red Hat AI Inference (RHAII) project. When set, no project is created and this one is read instead. `resource_tags` and `access_tags` are ignored."
  default     = null
}

variable "plan" {
  type        = string
  description = "The name of the pricing plan of the Red Hat AI Inference (RHAII) project. The plan cannot be changed after the project is created; a new plan replaces the project. [Learn more](https://cloud.ibm.com/docs/inference)."
  default     = "instructlab-pricing-plan"
  nullable    = false
}

variable "resource_tags" {
  type        = list(string)
  description = "List of user tags to add to the Red Hat AI Inference (RHAII) project. Only used when a new project is created."
  default     = []
  nullable    = false
}

variable "access_tags" {
  type        = list(string)
  description = "List of access management tags to add to the Red Hat AI Inference (RHAII) project, in `key:value` format. The tags must already exist in the account. Only used when a new project is created."
  default     = []
  nullable    = false
}

variable "list_inference_models" {
  type        = bool
  description = "Set to `true` to read the list of inference models that are available in the project and return their IDs in the `available_inference_model_ids` output. Terraform must be able to reach the Red Hat AI Inference API endpoint."
  default     = false
  nullable    = false
}

variable "inference_models" {
  type        = list(string)
  description = "List of inference model IDs to read from the project, for example `[\"llama-3-3-70b-instruct\"]`. The plan fails if a model is not available in the project. The details are returned in the `inference_models` output. Terraform must be able to reach the Red Hat AI Inference API endpoint."
  default     = []
  nullable    = false
}
