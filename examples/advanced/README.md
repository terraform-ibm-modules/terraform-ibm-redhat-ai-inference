# Advanced example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<!-- END SCHEMATICS DEPLOY HOOK -->

An end-to-end advanced example that will provision the following:
- A new resource group if one is not passed in.
- A new access management tag.
- A new Red Hat AI Inference project with user tags and the access tag, using the root level module.
- A lookup of the inference models that are available in the project, and the details of the `llama-3-3-70b-instruct` model.
