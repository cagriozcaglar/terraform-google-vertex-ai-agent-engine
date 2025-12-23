terraform {
  # This module is tested with Google Provider version 5.25.0.
  # It is recommended to use a recent version of the Google Provider.
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.25.0"
    }
  }
}
