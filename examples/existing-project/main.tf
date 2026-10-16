########################################################################################################################
# Existing Red Hat AI Inference project
########################################################################################################################

# Read an existing project and the inference models that are available in it. The module does not create, change or
# delete the project.
module "rhaii" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/redhat-ai-inference/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  existing_project_id   = var.existing_project_id
  list_inference_models = true
}
