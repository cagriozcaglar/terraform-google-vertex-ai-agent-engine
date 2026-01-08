locals {
  # A local variable to determine if the main agent resources should be created.
  # This requires the essential variables to be non-null.
  create_agent = var.project_id != null && var.location != null && var.display_name != null && var.time_zone != null

  # A local variable to determine if the datastore and its related resources should be created.
  # This requires the agent to be created and a datastore config to be provided.
  create_datastore = local.create_agent && var.datastore_config != null
}

#
# Creates the core Vertex AI Agent, which is a Dialogflow CX Agent.
# This agent is only created if all required variables (project_id, location, display_name, time_zone) are provided.
#
resource "google_dialogflow_cx_agent" "main" {
  # Conditionally create this resource.
  count = local.create_agent ? 1 : 0

  # The human-readable name for the agent.
  display_name = var.display_name
  # The location of the agent.
  location = var.location
  # The project ID where the agent will be created.
  project = var.project_id
  # The default language for the agent.
  default_language_code = var.default_language_code
  # The time zone for the agent.
  time_zone = var.time_zone
  # An optional description of the agent.
  description = var.description
  # An optional URI for the agent's avatar image.
  avatar_uri = var.avatar_uri
  # Whether to enable Stackdriver logging for the agent.
  enable_stackdriver_logging = var.enable_stackdriver_logging
  # Whether to enable automatic spell correction.
  enable_spell_correction = var.enable_spell_correction

  # Conditionally creates the advanced_settings block if the variable is provided.
  # This block configures settings like logging and audio export.
  dynamic "advanced_settings" {
    for_each = var.advanced_settings != null ? [var.advanced_settings] : []
    content {
      # Conditionally creates the nested audio_export_gcs_destination block.
      dynamic "audio_export_gcs_destination" {
        for_each = lookup(advanced_settings.value, "audio_export_gcs_destination", null) != null ? [lookup(advanced_settings.value, "audio_export_gcs_destination", null)] : []
        content {
          uri = lookup(audio_export_gcs_destination.value, "uri", null)
        }
      }
    }
  }

  # Conditionally creates the gen_app_builder_settings block if the variable is provided.
  # This block enables generative AI features, like RAG and generative fallback.
  dynamic "gen_app_builder_settings" {
    for_each = var.gen_app_builder_settings != null ? [var.gen_app_builder_settings] : []
    content {
      engine = lookup(gen_app_builder_settings.value, "engine", null)
    }
  }

  # Conditionally creates the text_to_speech_settings block if the variable is provided.
  # This block configures the agent's text-to-speech voice.
  dynamic "text_to_speech_settings" {
    for_each = var.text_to_speech_settings != null ? [var.text_to_speech_settings] : []
    content {
      synthesize_speech_configs = lookup(text_to_speech_settings.value, "synthesize_speech_configs", null)
    }
  }

  # Conditionally creates the speech_to_text_settings block if the variable is provided.
  # This block configures speech-to-text behavior.
  dynamic "speech_to_text_settings" {
    for_each = var.speech_to_text_settings != null ? [var.speech_to_text_settings] : []
    content {
      enable_speech_adaptation = lookup(speech_to_text_settings.value, "enable_speech_adaptation", null)
    }
  }
}

#
# Creates one or more tools for the agent based on the `tools` variable.
# Tools allow the agent to interact with external services via an OpenAPI specification.
# These are only created if the agent itself is being created.
#
resource "google_dialogflow_cx_tool" "main" {
  # Use the google-beta provider as this is a beta feature.
  provider = google-beta

  # Iterate over the map of tool configurations provided in the `var.tools` variable, but only if the agent is being created.
  for_each = local.create_agent ? var.tools : {}

  # The parent agent for this tool.
  parent = google_dialogflow_cx_agent.main[0].id
  # The human-readable name for the tool.
  display_name = each.value.display_name
  # An optional description of the tool's purpose.
  description = each.value.description

  # The OpenAPI 3.0 specification that defines the tool's functionality.
  open_api_spec {
    # The OpenAPI spec provided as a string.
    text_schema = each.value.openapi_spec_schema
  }
}

#
# Conditionally creates a Discovery Engine Datastore to serve as a knowledge base.
# This is used for Retrieval-Augmented Generation (RAG) capabilities.
#
resource "google_discovery_engine_data_store" "main" {
  # Use the google-beta provider as this is a beta feature.
  provider = google-beta

  # Create this resource only if the agent is being created and a `datastore_config` is provided.
  count = local.create_datastore ? 1 : 0

  # The project ID where the datastore will be created.
  project = var.project_id
  # The location of the datastore (e.g., 'global', 'us').
  location = var.datastore_location
  # The ID of the datastore. Must be unique in the project and location.
  data_store_id = var.datastore_config.data_store_id
  # The human-readable name for the datastore.
  display_name = var.datastore_config.display_name
  # The industry vertical of the datastore.
  industry_vertical = var.datastore_config.industry_vertical
  # The solutions that the datastore is configured for (e.g., 'SOLUTION_TYPE_SEARCH').
  solution_types = var.datastore_config.solution_types
  # The type of content stored in the datastore (e.g., 'CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT').
  content_config = var.datastore_config.content_config
}

#
# Conditionally creates the service identity for Discovery Engine.
# This service account is required for the datastore to access data sources, such as GCS buckets.
#
resource "google_project_service_identity" "gcp_sa_vert_search" {
  # Use the google-beta provider.
  provider = google-beta

  # Create this resource only if a datastore is being created.
  count = local.create_datastore ? 1 : 0

  # The project ID where the service identity will be created.
  project = var.project_id
  # The service for which to create the identity.
  service = "discoveryengine.googleapis.com"
}
