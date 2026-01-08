terraform {
  # This block specifies the required Terraform version and provider versions.
  # It ensures that the module is used with compatible versions of Terraform and the Google Cloud provider.
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.15.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.15.0"
    }
  }
}
