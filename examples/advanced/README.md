# Advanced example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=redhat-ai-inference-advanced-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples/advanced">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

An end-to-end advanced example that will provision the following:
- A new resource group if one is not passed in.
- A new access management tag.
- A new Red Hat AI Inference project with user tags and the access tag, using the root level module.
- A lookup of the inference models that are available in the project, and the details of the `llama-3-3-70b-instruct` model.
