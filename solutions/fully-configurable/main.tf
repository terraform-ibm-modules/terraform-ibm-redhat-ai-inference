########################################################################################################################
# Resource group
# Only looked up when a new project is created. An existing project does not need a resource group.
########################################################################################################################

locals {
  create_project = var.existing_project_id == null

  # Prefix is optional. A null or empty value skips it.
  prefix       = var.prefix != null && var.prefix != "" ? var.prefix : null
  project_name = local.prefix != null ? "${local.prefix}-${var.project_name}" : var.project_name
}

module "resource_group" {
  count                        = local.create_project ? 1 : 0
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.6.1"
  existing_resource_group_name = var.existing_resource_group_name
}

########################################################################################################################
# Red Hat AI Inference project
########################################################################################################################

module "rhaii" {
  source  = "terraform-ibm-modules/redhat-ai-inference/ibm"
  version = "1.0.0"

  # The module requires exactly one of project_name or existing_project_id
  project_name        = local.create_project ? local.project_name : null
  existing_project_id = var.existing_project_id
  resource_group_id   = local.create_project ? module.resource_group[0].resource_group_id : null

  region                = var.region
  plan                  = var.plan
  resource_tags         = var.resource_tags
  access_tags           = var.access_tags
  list_inference_models = var.list_inference_models
  inference_models      = var.inference_models
}
