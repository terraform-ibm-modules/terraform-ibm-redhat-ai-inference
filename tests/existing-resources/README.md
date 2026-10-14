# Existing resources

This configuration creates the resources that the existing-project example test needs:
- A new resource group if one is not passed in.
- A new Red Hat AI Inference project.

The test in `other_test.go` applies this configuration, runs the `examples/existing-project` example against the new project, and then destroys it.
