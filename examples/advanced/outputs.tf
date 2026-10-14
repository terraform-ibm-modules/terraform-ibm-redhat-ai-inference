########################################################################################################################
# Outputs
########################################################################################################################

output "id" {
  description = "The unique identifier of the project."
  value       = module.rhaii.id
}

output "crn" {
  description = "The CRN of the project."
  value       = module.rhaii.crn
}

output "project_id" {
  description = "The ID of the project. Use this value as project_id in the Red Hat AI Inference API."
  value       = module.rhaii.project_id
}

output "endpoint" {
  description = "The public base URL of the Red Hat AI Inference API for this project."
  value       = module.rhaii.endpoint
}

output "private_endpoint" {
  description = "The private base URL of the Red Hat AI Inference API for this project."
  value       = module.rhaii.private_endpoint
}

output "available_inference_model_ids" {
  description = "The IDs of the inference models that are available in the project."
  value       = module.rhaii.available_inference_model_ids
}

output "inference_models" {
  description = "Details of the selected inference models, keyed by model ID."
  value       = module.rhaii.inference_models
}

output "resource_group_name" {
  description = "Resource group name."
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "Resource group ID."
  value       = module.resource_group.resource_group_id
}
