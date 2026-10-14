terraform {
  required_version = ">= 1.9.0"

  # Ensure that there is always 1 example locked into the latest provider version
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 2.8.0, < 3.0.0"
    }
  }
}
