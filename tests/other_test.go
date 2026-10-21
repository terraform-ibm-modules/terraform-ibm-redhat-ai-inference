// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const existingProjectExampleDir = "examples/existing-project"

// Consistency test for the existing-project example. A new project is created first with the configuration in
// tests/existing-resources, and destroyed at the end of the test.
func TestRunExistingProjectExample(t *testing.T) {
	t.Parallel()

	prefix := fmt.Sprintf("rhaii-exist-%s", strings.ToLower(random.UniqueID()))
	realTerraformDir := ".."
	tempTerraformDir, err := files.CopyTerraformFolderToTemp(realTerraformDir, prefix)
	require.NoError(t, err, "Failed to copy the module to a temporary directory")

	apiKey := os.Getenv("TF_VAR_ibmcloud_api_key")
	require.NotEmpty(t, apiKey, "TF_VAR_ibmcloud_api_key must be set")

	existingTerraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: tempTerraformDir + "/tests/existing-resources",
		Vars: map[string]interface{}{
			"prefix":         prefix,
			"region":         region,
			"resource_group": resourceGroup,
		},
		// Set Upgrade to true to ensure latest version of providers and modules are used by terratest.
		// This is the same as setting the -upgrade=true flag with terraform.
		Upgrade: true,
	})

	terraform.WorkspaceSelectOrNewContext(t, context.Background(), existingTerraformOptions, prefix)
	_, existErr := terraform.InitAndApplyContextE(t, context.Background(), existingTerraformOptions)

	if existErr != nil {
		assert.True(t, existErr == nil, "Init and Apply of temp existing resource failed")
	} else {
		options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
			Testing:      t,
			TerraformDir: existingProjectExampleDir,
			Prefix:       "rhaii-exist-ex",
			Region:       region,
			TerraformVars: map[string]interface{}{
				"existing_project_id": terraform.OutputContext(t, context.Background(), existingTerraformOptions, "project_crn"),
			},
		})

		output, err := options.RunTestConsistency()
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}

	// Check if "DO_NOT_DESTROY_ON_FAILURE" is set
	envVal, _ := os.LookupEnv("DO_NOT_DESTROY_ON_FAILURE")
	// Destroy the temporary existing resources if required
	if t.Failed() && strings.ToLower(envVal) == "true" {
		fmt.Println("Terratest failed. Debug the test and delete resources manually.")
	} else {
		logger.Log(t, "START: Destroy (existing resources)")
		terraform.DestroyContext(t, context.Background(), existingTerraformOptions)
		terraform.WorkspaceDeleteContext(t, context.Background(), existingTerraformOptions, prefix)
		logger.Log(t, "END: Destroy (existing resources)")
	}
}
