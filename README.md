# Red Hat AI Inference module

[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-redhat-ai-inference?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://pre-commit.com/)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://semantic-release.gitbook.io/semantic-release/)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-623CE4?logo=terraform)](https://registry.terraform.io/modules/terraform-ibm-modules/redhat-ai-inference/ibm/latest)

Use this module to create and configure a Red Hat AI Inference (RHAII) project on IBM Cloud.

A Red Hat AI Inference project is an instance of the `instructlab` service in the IBM Cloud resource controller. The project gives you a dedicated endpoint for the Red Hat AI Inference API, which serves OpenAI compatible chat completion, completion, embedding and rerank requests on the models that are available in the project.

The module can:
- Create a new project, or read an existing project by its ID (GUID) or CRN.
- Add user tags and access management tags to a new project.
- Read the list of inference models that are available in the project.
- Read the details of specific inference models, so that the plan fails early when a model that your application needs is not available.

The module returns the public and private endpoints of the project, which you can pass to applications, for example a Code Engine app.

For more information, see [Red Hat AI Inference on IBM Cloud](https://cloud.ibm.com/docs/inference) and the [Red Hat AI Inference API](https://cloud.ibm.com/docs/apis/inference).

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
<ul>
  <li><a href="#terraform-ibm-redhat-ai-inference">terraform-ibm-redhat-ai-inference</a></li>
  <li><a href="https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples">Examples</a>
    <ul>
      <li>
        <a href="https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples/advanced">Advanced example</a>
        <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=redhat-ai-inference-advanced-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples/advanced"><img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom; margin-left: 5px;"></a>
      </li>
      <li>
        <a href="https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples/existing-project">Existing project example</a>
        <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=redhat-ai-inference-existing-project-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples/existing-project"><img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom; margin-left: 5px;"></a>
      </li>
    </ul>
    ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
  </li>
  <li><a href="#known-issues">Known issues</a></li>
  <li><a href="#contributing">Contributing</a></li>
</ul>
<!-- END OVERVIEW HOOK -->

## terraform-ibm-redhat-ai-inference

### Usage

Create a new project:

```hcl
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "2.8.0" # Lock into a provider version that satisfies the module constraints
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX" # replace with apikey value
  region           = "us-east"
}

module "rhaii" {
  source            = "terraform-ibm-modules/redhat-ai-inference/ibm"
  version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  project_name      = "my-rhaii-project"
  region            = "us-east"
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX" # Replace with the actual ID of resource group to use
  resource_tags     = ["env:dev"]
  access_tags       = ["project:rhaii"] # The access tag must already exist in the account

  # Fail the plan if a model that the application needs is not available in the project
  inference_models = ["llama-3-3-70b-instruct"]
}
```

Use an existing project:

```hcl
module "rhaii" {
  source              = "terraform-ibm-modules/redhat-ai-inference/ibm"
  version             = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  existing_project_id = "crn:v1:bluemix:public:instructlab:us-east:a/<account_id>:<project_id>::" # The GUID also works
}
```

Call the inference API with the outputs of the module:

```sh
curl -X POST "$(terraform output -raw endpoint)/chat/completions" \
  -H "Authorization: Bearer $(ibmcloud iam oauth-tokens --output json | jq -r .iam_token | cut -d' ' -f2)" \
  -H "Content-Type: application/json" \
  -d '{"model": "llama-3-3-70b-instruct", "messages": [{"role": "user", "content": "Hello"}]}'
```

### Endpoints

The project has a public and a private endpoint:
- `endpoint`: `https://<region>.rhai.ibm.com/v1/projects/<project_id>`
- `private_endpoint`: `https://private.<region>.rhai.ibm.com/v1/projects/<project_id>`. It can be reached only from the IBM Cloud private network, for example from a VPC.

The `list_inference_models` and `inference_models` inputs make Terraform call the Red Hat AI Inference API during the plan. The provider picks the endpoint from its `visibility` argument (`public` by default). When you set `visibility = "private"` in the provider, Terraform must run on the IBM Cloud private network. Leave both inputs at their defaults if Terraform cannot reach the API.

### Required access policies

You need the following permissions to run this module:

- Resource group only
    - `Viewer` access on the specific resource group
- **Red Hat AI Inference** (`instructlab`) service
    - `Editor` platform access, to create, update and delete the project
    - A service access role that allows reading inference models, when `list_inference_models` is `true` or `inference_models` is not empty
- Tagging service
    - `Administrator` access, to attach access management tags, when `access_tags` is not empty

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 2.8.0, < 3.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
| ---- | ---- |
| [ibm_rhaii_project.project](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/rhaii_project) | resource |
| [ibm_rhaii_inference_model.model](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/rhaii_inference_model) | data source |
| [ibm_rhaii_inference_models.models](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/rhaii_inference_models) | data source |
| [ibm_rhaii_project.existing](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/rhaii_project) | data source |

### Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | List of access management tags to add to the Red Hat AI Inference (RHAII) project, in `key:value` format. The tags must already exist in the account. Only used when `project_name` is set. | `list(string)` | `[]` | no |
| <a name="input_existing_project_id"></a> [existing\_project\_id](#input\_existing\_project\_id) | The ID (GUID) or CRN of an existing Red Hat AI Inference (RHAII) project. When set, the module does not create a project and reads this one instead. | `string` | `null` | no |
| <a name="input_inference_models"></a> [inference\_models](#input\_inference\_models) | List of inference model IDs to read from the Red Hat AI Inference (RHAII) project, for example `["llama-3-3-70b-instruct"]`. The plan fails if a model is not available in the project. The details are returned in the `inference_models` output. Terraform must be able to reach the Red Hat AI Inference API endpoint. | `list(string)` | `[]` | no |
| <a name="input_list_inference_models"></a> [list\_inference\_models](#input\_list\_inference\_models) | Set to `true` to read the list of inference models that are available in the Red Hat AI Inference (RHAII) project and return their IDs in the `available_inference_model_ids` output. Terraform must be able to reach the Red Hat AI Inference API endpoint. | `bool` | `false` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the pricing plan of the Red Hat AI Inference (RHAII) project. The plan cannot be changed after the project is created; a new plan replaces the project. [Learn more](https://cloud.ibm.com/docs/inference). | `string` | `"instructlab-pricing-plan"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the Red Hat AI Inference (RHAII) project to create. Set this or `existing_project_id`, not both. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the Red Hat AI Inference (RHAII) project is created. Only `us-east` is supported. [Learn more](https://cloud.ibm.com/docs/inference). | `string` | `"us-east"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group where the Red Hat AI Inference (RHAII) project is created. Required when `project_name` is set. | `string` | `null` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | List of user tags to add to the Red Hat AI Inference (RHAII) project. Only used when `project_name` is set. | `list(string)` | `[]` | no |

### Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The ID of the account that owns the Red Hat AI Inference (RHAII) project. |
| <a name="output_available_inference_model_ids"></a> [available\_inference\_model\_ids](#output\_available\_inference\_model\_ids) | The IDs of the inference models that are available in the Red Hat AI Inference (RHAII) project. Empty when `list_inference_models` is `false`. |
| <a name="output_crn"></a> [crn](#output\_crn) | The CRN of the Red Hat AI Inference (RHAII) project. |
| <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url) | The relative URL of the Red Hat AI Inference (RHAII) project in the IBM Cloud console. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The public base URL of the API for this Red Hat AI Inference (RHAII) project. |
| <a name="output_guid"></a> [guid](#output\_guid) | The GUID of the Red Hat AI Inference (RHAII) project resource instance. |
| <a name="output_inference_models"></a> [inference\_models](#output\_inference\_models) | Details of the inference models in `inference_models`, keyed by model ID. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Red Hat AI Inference (RHAII) project. |
| <a name="output_plan_id"></a> [plan\_id](#output\_plan\_id) | The global catalog ID of the pricing plan of the Red Hat AI Inference (RHAII) project. |
| <a name="output_private_endpoint"></a> [private\_endpoint](#output\_private\_endpoint) | The private base URL of the API for this Red Hat AI Inference (RHAII) project. It can be reached only from the IBM Cloud private network. |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the Red Hat AI Inference (RHAII) project. Use this value as `project_id` in the API. |
| <a name="output_region"></a> [region](#output\_region) | The region of the Red Hat AI Inference (RHAII) project. |
| <a name="output_state"></a> [state](#output\_state) | The state of the Red Hat AI Inference (RHAII) project, for example `active`. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Known issues

- The service is available only in the `us-east` region and on the `instructlab-pricing-plan` plan today.
- The plan of a project cannot be changed. A change to `plan` or `region` replaces the project.
- `resource_tags` and `access_tags` are ignored when `existing_project_id` is set. Manage the tags of an existing project where the project is created.

## Contributing

You can report issues and request features for this module in the issues of the module repo.

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
