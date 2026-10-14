terraform {
  required_version = ">= 1.9.0"

  # Lock this example into the lowest provider version of the range defined in the main module's version.tf
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "2.8.0"
    }
  }
}
