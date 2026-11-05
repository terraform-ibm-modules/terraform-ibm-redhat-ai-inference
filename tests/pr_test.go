// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"

// Red Hat AI Inference is only available in us-east today
const region = "us-east"

// Ensure every example directory has a corresponding test
const advancedExampleDir = "examples/advanced"

// Deployable architecture (DA) solution
const fullyConfigurableDADir = "solutions/fully-configurable"

// This should match the terraform_version in the ibm_catalog.json
const terraformVersion = "terraform_v1.12.2"

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

	// TODO: Remove t.Skip once the initial release (v1.0.0) is published to main
	t.Skip("Skipping upgrade test for initial module release")

	options := setupOptions(t, "rhaii-upg", advancedExampleDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func setupSchematicOptions(t *testing.T, prefix string, dir string) *testschematic.TestSchematicOptions {
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing:                    t,
		TarIncludePatterns:         []string{"*.tf", fmt.Sprintf("%s/*.tf", dir)},
		TemplateFolder:             dir,
		Prefix:                     prefix,
		Tags:                       []string{"test-schematic", "rhaii-da"},
		DeleteWorkspaceOnFail:      false,
		WaitJobCompleteMinutes:     60,
		Region:                     region,
		TerraformVersion:           terraformVersion,
		CheckApplyResultForUpgrade: true,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "region", Value: options.Region, DataType: "string"},
		{Name: "resource_tags", Value: options.Tags, DataType: "list(string)"},
	}

	return options
}

// Deploy the fully-configurable DA in Schematics
func TestRunFullyConfigurableDA(t *testing.T) {
	t.Parallel()

	options := setupSchematicOptions(t, "rhaii-da", fullyConfigurableDADir)

	err := options.RunSchematicTest()
	assert.NoError(t, err, "Schematic Test had an unexpected error")
}

// Upgrade test for the fully-configurable DA
func TestRunUpgradeFullyConfigurableDA(t *testing.T) {
	t.Parallel()

	// TODO: Remove t.Skip once a release that includes this DA is published to main
	t.Skip("Skipping DA upgrade test until the DA is released")

	options := setupSchematicOptions(t, "rhaii-da-up", fullyConfigurableDADir)

	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.NoError(t, err, "Schematic Test had an unexpected error")
	}
}
