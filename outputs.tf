########################################################################################################################
# Outputs
########################################################################################################################

output "crn" {
  description = "The CRN of the Red Hat AI Inference (RHAII) project."
  value       = local.project.crn
}

output "guid" {
  description = "The GUID of the Red Hat AI Inference (RHAII) project resource instance."
  value       = local.project.guid
}

output "project_id" {
  description = "The ID of the Red Hat AI Inference (RHAII) project. Use this value as `project_id` in the API."
  value       = local.project.project_id
}

output "name" {
  description = "The name of the Red Hat AI Inference (RHAII) project."
  value       = local.project.name
}

output "account_id" {
  description = "The ID of the account that owns the Red Hat AI Inference (RHAII) project."
  value       = local.project.account_id
}

output "region" {
  description = "The region of the Red Hat AI Inference (RHAII) project."
  value       = local.region
}

output "plan_id" {
  description = "The global catalog ID of the pricing plan of the Red Hat AI Inference (RHAII) project."
  value       = local.project.plan_id
}

output "state" {
  description = "The state of the Red Hat AI Inference (RHAII) project, for example `active`."
  value       = local.project.state
}

output "endpoint" {
  description = "The public base URL of the API for this Red Hat AI Inference (RHAII) project."
  value       = local.project.endpoint
}

output "private_endpoint" {
  description = "The private base URL of the API for this Red Hat AI Inference (RHAII) project. It can be reached only from the IBM Cloud private network."
  value       = local.project.private_endpoint
}

output "dashboard_url" {
  description = "The relative URL of the Red Hat AI Inference (RHAII) project in the IBM Cloud console."
  value       = local.project.dashboard_url
}

output "available_inference_model_ids" {
  description = "The IDs of the inference models that are available in the Red Hat AI Inference (RHAII) project. Empty when `list_inference_models` is `false`."
  value       = var.list_inference_models ? data.ibm_rhaii_inference_models.models[0].models[*].id : []
}

output "inference_models" {
  description = "Details of the inference models in `inference_models`, keyed by model ID."
  value = {
    for id, model in data.ibm_rhaii_inference_model.model : id => {
      name         = model.name
      display_name = model.display_name
      model_type   = model.model_type
      state        = model.state
      status       = model.status
      total_params = model.total_params
    }
  }
}
