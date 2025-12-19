terraform {
  # Specifies the minimum version of Terraform that can be used with this module.
  required_version = ">= 1.3"

  # Defines the required providers and their versions.
  required_providers {
    # The Discovery Engine resources are only available in the google-beta provider.
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.36.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}
