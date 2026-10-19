// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"

// Red Hat AI Inference is only available in us-east today
const region = "us-east"

// Ensure every example directory has a corresponding test
const advancedExampleDir = "examples/advanced"

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		Region:        region,
	})
	// The advanced example hardcodes the region and does not take resource tags, so only pass the variables it declares
	options.TerraformVars = map[string]interface{}{
		"prefix":         options.Prefix,
		"resource_group": resourceGroup,
	}
	return options
}

// Consistency test for the advanced example
func TestRunAdvancedExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "rhaii-adv", advancedExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// Upgrade test (using advanced example)
func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "rhaii-upg", advancedExampleDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
