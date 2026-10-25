########################################################################################################################
# Outputs
########################################################################################################################

output "crn" {
  description = "The CRN of the Red Hat AI Inference (RHAII) project."
  value       = module.rhaii.crn
}

output "guid" {
  description = "The GUID of the Red Hat AI Inference (RHAII) project resource instance."
  value       = module.rhaii.guid
}

output "project_id" {
  description = "The ID of the Red Hat AI Inference (RHAII) project. Use this value as `project_id` in the API."
  value       = module.rhaii.project_id
}

output "name" {
  description = "The name of the Red Hat AI Inference (RHAII) project."
  value       = module.rhaii.name
}

output "account_id" {
  description = "The ID of the account that owns the Red Hat AI Inference (RHAII) project."
  value       = module.rhaii.account_id
}

output "region" {
  description = "The region of the Red Hat AI Inference (RHAII) project."
  value       = module.rhaii.region
}

output "plan_id" {
  description = "The global catalog ID of the pricing plan of the Red Hat AI Inference (RHAII) project."
  value       = module.rhaii.plan_id
}

output "state" {
  description = "The state of the Red Hat AI Inference (RHAII) project, for example `active`."
  value       = module.rhaii.state
}

output "endpoint" {
  description = "The public base URL of the API for this Red Hat AI Inference (RHAII) project."
  value       = module.rhaii.endpoint
}

output "private_endpoint" {
  description = "The private base URL of the API for this Red Hat AI Inference (RHAII) project. It can be reached only from the IBM Cloud private network."
  value       = module.rhaii.private_endpoint
}

output "dashboard_url" {
  description = "The relative URL of the Red Hat AI Inference (RHAII) project in the IBM Cloud console."
  value       = module.rhaii.dashboard_url
}

output "available_inference_model_ids" {
  description = "The IDs of the inference models that are available in the project. Empty when `list_inference_models` is `false`."
  value       = module.rhaii.available_inference_model_ids
}

output "inference_models" {
  description = "Details of the inference models in `inference_models`, keyed by model ID."
  value       = module.rhaii.inference_models
}

output "resource_group_id" {
  description = "The ID of the resource group that contains the project. Null when an existing project is used."
  value       = one(module.resource_group[*].resource_group_id)
}

output "resource_group_name" {
  description = "The name of the resource group that contains the project. Null when an existing project is used."
  value       = one(module.resource_group[*].resource_group_name)
}
