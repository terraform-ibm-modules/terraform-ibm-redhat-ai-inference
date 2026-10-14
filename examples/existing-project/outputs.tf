########################################################################################################################
# Outputs
########################################################################################################################

output "name" {
  description = "The name of the existing project."
  value       = module.rhaii.name
}

output "project_id" {
  description = "The ID of the project. Use this value as project_id in the Red Hat AI Inference API."
  value       = module.rhaii.project_id
}

output "region" {
  description = "The region of the project, read from its CRN."
  value       = module.rhaii.region
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
