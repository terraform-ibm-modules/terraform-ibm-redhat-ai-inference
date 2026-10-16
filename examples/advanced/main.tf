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
# Access tag
########################################################################################################################

# Access tags must exist in the account before they can be attached to the project.
resource "ibm_iam_access_tag" "rhaii" {
  name = "${var.prefix}:rhaii"
}

########################################################################################################################
# Red Hat AI Inference project
########################################################################################################################

module "rhaii" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/redhat-ai-inference/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  project_name      = "${var.prefix}-rhaii"
  region            = var.region
  resource_group_id = module.resource_group.resource_group_id
  resource_tags     = var.resource_tags
  access_tags       = [ibm_iam_access_tag.rhaii.name]
  # Read the list of models that are available in the project, and the details of one model.
  list_inference_models = true
  inference_models      = ["llama-3-3-70b-instruct"]
}
