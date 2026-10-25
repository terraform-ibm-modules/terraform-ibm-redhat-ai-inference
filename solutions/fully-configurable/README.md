# Red Hat AI Inference deployable architecture (fully configurable)

Deploys a Red Hat AI Inference (RHAII) project on IBM Cloud. A project is an instance of the `instructlab` service. It gives you a dedicated endpoint for the Red Hat AI Inference API, which serves OpenAI compatible chat completion, completion, embedding and rerank requests on the models that are available in the project.

This solution wraps the [terraform-ibm-modules/redhat-ai-inference](https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference) module (version 1.0.0) and the [terraform-ibm-modules/resource-group](https://github.com/terraform-ibm-modules/terraform-ibm-resource-group) module.

## What it deploys

- A Red Hat AI Inference project in `us-east`, in an existing resource group. Alternatively, it reads an existing project when `existing_project_id` is set, and creates nothing.
- Optionally, a lookup of the inference models that are available in the project (`list_inference_models`) and of specific models (`inference_models`). The plan fails if a requested model is not available.

## Inputs

| Name | Description | Default | Required |
| ---- | ----------- | ------- | :------: |
| `ibmcloud_api_key` | The IBM Cloud API key used to deploy the resources. Sensitive. | none | yes |
| `prefix` | Prefix added to the project name. Null or empty skips it. | `null` | no |
| `existing_resource_group_name` | Existing resource group for the project. Not used with `existing_project_id`. | `Default` | no |
| `region` | Only `us-east` is supported. | `us-east` | no |
| `project_name` | Name of the project to create (the prefix is added in front). | `rhaii` | no |
| `existing_project_id` | ID (GUID) or CRN of an existing project to read instead of creating one. | `null` | no |
| `plan` | Pricing plan. Only `instructlab-pricing-plan` is supported. It cannot be changed after creation. | `instructlab-pricing-plan` | no |
| `resource_tags` | User tags for a new project. | `[]` | no |
| `access_tags` | Access management tags (`key:value`) for a new project. The tags must already exist. | `[]` | no |
| `list_inference_models` | Return the IDs of the available models. Terraform must reach the API endpoint. | `false` | no |
| `inference_models` | Model IDs to read, for example `["llama-3-3-70b-instruct"]`. Terraform must reach the API endpoint. | `[]` | no |
| `provider_visibility` | `public` or `private` provider endpoints. Use `private` only when Terraform runs on the IBM Cloud private network. | `public` | no |

## Outputs

`crn`, `guid`, `project_id`, `name`, `account_id`, `region`, `plan_id`, `state`, `endpoint`, `private_endpoint`, `dashboard_url`, `available_inference_model_ids`, `inference_models`, `resource_group_id`, `resource_group_name`.

## Required access policies

- Resource group only: `Viewer` on the resource group.
- Red Hat AI Inference (`instructlab`) service: `Editor` platform access to create, update and delete the project. A service access role that allows reading inference models is also needed when `list_inference_models` is `true` or `inference_models` is not empty.
- Tagging service: `Administrator`, to attach access management tags when `access_tags` is not empty.

## Known limits

- The service is available only in `us-east` and on the `instructlab-pricing-plan` plan.
- A change to `plan` or `region` replaces the project.
- `resource_tags` and `access_tags` are ignored when `existing_project_id` is set.

## Call the API

```sh
curl -X POST "$(terraform output -raw endpoint)/chat/completions" \
  -H "Authorization: Bearer $(ibmcloud iam oauth-tokens --output json | jq -r .iam_token | cut -d' ' -f2)" \
  -H "Content-Type: application/json" \
  -d '{"model": "llama-3-3-70b-instruct", "messages": [{"role": "user", "content": "Hello"}]}'
```
