########################################################################################################################
# Red Hat AI Inference project
########################################################################################################################

locals {
  create_project = var.project_name != null

  project = local.create_project ? {
    crn              = ibm_rhaii_project.project[0].crn
    guid             = ibm_rhaii_project.project[0].guid
    project_id       = ibm_rhaii_project.project[0].project_id
    name             = ibm_rhaii_project.project[0].name
    account_id       = ibm_rhaii_project.project[0].account_id
    plan_id          = ibm_rhaii_project.project[0].plan_id
    state            = ibm_rhaii_project.project[0].state
    endpoint         = ibm_rhaii_project.project[0].endpoint
    private_endpoint = ibm_rhaii_project.project[0].private_endpoint
    dashboard_url    = ibm_rhaii_project.project[0].dashboard_url
    } : {
    crn              = data.ibm_rhaii_project.existing[0].crn
    guid             = data.ibm_rhaii_project.existing[0].guid
    project_id       = data.ibm_rhaii_project.existing[0].project_id
    name             = data.ibm_rhaii_project.existing[0].name
    account_id       = data.ibm_rhaii_project.existing[0].account_id
    plan_id          = data.ibm_rhaii_project.existing[0].plan_id
    state            = data.ibm_rhaii_project.existing[0].state
    endpoint         = data.ibm_rhaii_project.existing[0].endpoint
    private_endpoint = data.ibm_rhaii_project.existing[0].private_endpoint
    dashboard_url    = data.ibm_rhaii_project.existing[0].dashboard_url
  }

  region = local.create_project ? var.region : split(":", data.ibm_rhaii_project.existing[0].crn)[5]
}

# Changing plan_name or location forces replacement (destroys and recreates the project)
resource "ibm_rhaii_project" "project" {
  count             = local.create_project ? 1 : 0
  name              = var.project_name
  plan_name         = var.plan
  location          = var.region
  resource_group_id = var.resource_group_id
  tags              = var.resource_tags
  access_tags       = var.access_tags

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

data "ibm_rhaii_project" "existing" {
  count      = local.create_project ? 0 : 1
  identifier = var.existing_project_id
}

########################################################################################################################
# Inference models
########################################################################################################################

data "ibm_rhaii_inference_models" "models" {
  count      = var.list_inference_models ? 1 : 0
  project_id = local.project.project_id
  location   = local.region
}

data "ibm_rhaii_inference_model" "model" {
  for_each   = toset(var.inference_models)
  project_id = local.project.project_id
  location   = local.region
  model      = each.value
}
