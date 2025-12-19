# The versions.tf file is used to specify the required Terraform version and provider versions.
terraform {
  # Specifies the minimum version of Terraform required to apply this configuration.
  required_version = ">= 1.3"

  # Specifies the required providers and their versions.
  required_providers {
    # The Google Provider is used to interact with Google Cloud resources.
    google = {
      # The source of the Google Provider.
      source  = "hashicorp/google"
      # The required version of the Google Provider.
      version = ">= 5.0"
    }
  }
}
