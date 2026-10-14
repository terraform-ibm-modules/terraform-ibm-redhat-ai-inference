terraform {
  # require 1.9 or later to make use of cross-object referencing for input variable validations
  #   more info: https://www.hashicorp.com/blog/terraform-1-9-enhances-input-variable-validations
  required_version = ">= 1.9.0"

  required_providers {
    # Use "greater than or equal to" range in modules.
    # 2.8.0 is the first provider release with the ibm_rhaii_* resources and data sources.
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 2.8.0, < 3.0.0"
    }
  }
}
