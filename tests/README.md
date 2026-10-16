# Tests

Automated tests are written in Go using the `ibmcloud-terratest-wrapper` library.

## Prerequisites

- [Go](https://golang.org/dl/) >= 1.26.1
- [Terraform](https://www.terraform.io/downloads) >= 1.9.0
- An IBM Cloud account with appropriate IAM permissions
- The environment variable `TF_VAR_ibmcloud_api_key` set to a valid IBM Cloud API key

## Running the tests

```bash
cd tests
go test -v -run TestRunBasicExample -timeout 60m
go test -v -run TestRunAdvancedExample -timeout 60m
go test -v -run TestRunUpgradeExample -timeout 60m
```

To run all PR tests:

```bash
cd tests
go test -v -timeout 60m
```
