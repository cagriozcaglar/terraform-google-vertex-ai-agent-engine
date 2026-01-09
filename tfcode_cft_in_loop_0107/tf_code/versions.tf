terraform {
  # Specifies the minimum required version of Terraform.
  required_version = ">= 1.3"

  # Specifies the required providers and their versions.
  required_providers {
    # The Google Cloud provider.
    google = {
      # The official HashiCorp Google Cloud provider.
      source = "hashicorp/google"
      # Version 5.23.0 or higher is required for the google_discovery_engine_app resource.
      version = ">= 5.23.0"
    }
  }
}
