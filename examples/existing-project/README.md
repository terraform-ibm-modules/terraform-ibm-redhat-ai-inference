# Existing project example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=redhat-ai-inference-existing-project-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-redhat-ai-inference/tree/main/examples/existing-project">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

An example that shows how to consume an existing Red Hat AI Inference project with the `existing_project_id` input.

The example does not provision any resources. It reads the following:
- The existing project, by its ID (GUID) or CRN.
- The list of inference models that are available in the project.
