# Red Hat AI Inference deployable architecture (fully configurable)

Deploys a Red Hat AI Inference (RHAII) project on IBM Cloud. A project is an instance of the `instructlab` service. It gives you a dedicated endpoint for the Red Hat AI Inference API, which serves OpenAI compatible chat completion, completion, embedding and rerank requests on the models that are available in the project.

This solution wraps the module in the root of this repository and the [terraform-ibm-modules/resource-group](https://github.com/terraform-ibm-modules/terraform-ibm-resource-group) module.

## What it deploys

- A Red Hat AI Inference project in `us-east`, in an existing resource group. Alternatively, it reads an existing project when `existing_project_id` is set, and creates nothing.
- Optionally, a lookup of the inference models that are available in the project (`list_inference_models`) and of specific models (`inference_models`). The plan fails if a requested model is not available.

For the inputs and outputs, see [variables.tf](variables.tf) and [outputs.tf](outputs.tf).

## Required access policies

- Resource group only: `Viewer` on the resource group.
- Red Hat AI Inference (`instructlab`) service: `Editor` platform access to create, update and delete the project. `Reader` service access is also needed when `list_inference_models` is `true` or `inference_models` is not empty, to read the inference models.
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
