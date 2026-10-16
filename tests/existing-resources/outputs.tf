########################################################################################################################
# Outputs
########################################################################################################################

output "project_crn" {
  description = "The CRN of the project."
  value       = module.rhaii.crn
}

output "resource_group_name" {
  description = "Resource group name."
  value       = module.resource_group.resource_group_name
}
