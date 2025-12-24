# Specifies the version of Terraform and the required providers.
terraform {
  # This module is tested with Terraform 1.3 and higher.
  required_version = ">= 1.3"

  # Specifies the required provider for Google Cloud Platform.
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.31"
    }
  }
}
