########################################################################################################################
# Input Variables
########################################################################################################################

variable "project_name" {
  type        = string
  description = "The name of the Red Hat AI Inference project to create. Set this or `existing_project_id`, not both."
  default     = null

  validation {
    condition     = var.project_name == null || can(regex("^[a-zA-Z0-9 ._:-]{1,180}$", var.project_name))
    error_message = "The project name must be 1 to 180 characters long and contain only letters, numbers, spaces, '-', '.', '_' and ':'."
  }

  validation {
    condition     = (var.project_name == null) != (var.existing_project_id == null)
    error_message = "Set exactly one of 'project_name' (to create a new project) or 'existing_project_id' (to use an existing project)."
  }
}

variable "existing_project_id" {
  type        = string
  description = "The ID (GUID) or CRN of an existing Red Hat AI Inference project. When set, the module does not create a project and reads this one instead."
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "The ID of the resource group where the project is created. Required when `project_name` is set."
  default     = null

  validation {
    condition     = var.project_name == null || var.resource_group_id != null
    error_message = "'resource_group_id' is required when 'project_name' is set."
  }
}

variable "region" {
  type        = string
  description = "The region where the project is created. The service is available in `us-east` today."
  default     = "us-east"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+$", var.region))
    error_message = "The region must be an IBM Cloud region name, for example 'us-east'."
  }
}

variable "plan" {
  type        = string
  description = "The name of the pricing plan of the project. The plan cannot be changed after the project is created; a new plan replaces the project."
  default     = "instructlab-pricing-plan"
  nullable    = false

  validation {
    condition     = contains(["instructlab-pricing-plan"], var.plan)
    error_message = "The specified pricing plan is not available. The following plans are supported: 'instructlab-pricing-plan'."
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "List of user tags to add to the project. Only used when `project_name` is set."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for tag in var.resource_tags : can(regex("^[a-zA-Z0-9 _.:-]{1,128}$", tag))])
    error_message = "Each resource tag must be 1 to 128 characters long and contain only letters, numbers, spaces, '_', '.', '-' and ':'."
  }
}

variable "access_tags" {
  type        = list(string)
  description = "List of access management tags to add to the project, in `key:value` format. The tags must already exist in the account. Only used when `project_name` is set."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for tag in var.access_tags : can(regex("^[a-zA-Z0-9_.-]+:[a-zA-Z0-9 _.-]+$", tag))])
    error_message = "Each access tag must be in 'key:value' format, for example 'project:rhaii'."
  }
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

  validation {
    condition     = alltrue([for model in var.inference_models : can(regex("^[a-z0-9-]{1,100}$", model))])
    error_message = "Each inference model ID must be 1 to 100 characters long and contain only lowercase letters, numbers and '-'."
  }
}
