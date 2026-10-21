########################################################################################################################
# Resource group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.6.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# Red Hat AI Inference project
########################################################################################################################

module "rhaii" {
  source                = "../.."
  project_name          = "${var.prefix}-rhaii"
  region                = "us-east"
  resource_group_id     = module.resource_group.resource_group_id
  list_inference_models = true
  inference_models      = ["llama-3-3-70b-instruct"]
}
