# This resource provisions the service account that Vertex AI Search uses
# to access other GCP resources. It is created by enabling the API, but
# this ensures it exists and its identity is available to Terraform,
# which can prevent race conditions during app creation.
resource "google_project_service_identity" "discovery_engine_sa" {
  # The GCP project ID.
  project = var.project_id
  # The service for which to generate the service identity.
  service = "discoveryengine.googleapis.com"
}

# The Vertex AI Search App is the top-level container for engines and data stores.
# It provides the serving endpoint for search or chat queries.
resource "google_vertex_ai_search_app" "main" {
  # The GCP project ID.
  project = var.project_id
  # The GCP location for the resource.
  location = var.location
  # The user-friendly name for the App.
  display_name = var.app_display_name
  # Connects the app to one or more data stores by their IDs.
  data_store_ids = local.all_data_store_ids

  # This block contains configuration for the engine associated with the app.
  engine_config {
    # The unique ID for the Engine.
    engine_id = var.engine_id
    # Must match the solution type of the Data Stores.
    solution_type = var.solution_type

    # This block contains configuration specific to a search engine.
    # It is only included if the solution_type is 'SOLUTION_TYPE_SEARCH'.
    dynamic "search_engine_config" {
      for_each = var.solution_type == "SOLUTION_TYPE_SEARCH" ? [var.search_engine_config] : []
      content {
        # The search tier, e.g., 'SEARCH_TIER_STANDARD' or 'SEARCH_TIER_ENTERPRISE'.
        search_tier = search_engine_config.value.search_tier
        # Optional add-ons, such as 'SEARCH_ADD_ON_LLM' for summary features.
        search_add_ons = search_engine_config.value.search_add_ons
      }
    }

    # This block contains configuration specific to a conversational (chat) engine.
    # It is only included if the solution_type is 'SOLUTION_TYPE_CONVERSATION'.
    dynamic "chat_engine_config" {
      for_each = var.solution_type == "SOLUTION_TYPE_CONVERSATION" && var.chat_engine_config != null ? [var.chat_engine_config] : []
      content {
        # Configuration for the chat agent's persona and behavior.
        agent_creation_config {
          # The name of the company or business to be used in the agent's responses.
          business = chat_engine_config.value.business
          # The default language code for the agent, e.g., 'en'.
          default_language_code = chat_engine_config.value.default_language_code
          # The IANA time zone for the agent.
          time_zone = chat_engine_config.value.time_zone
        }
      }
    }
  }

  # This depends on any Data Stores being created first, and the service agent
  # for Discovery Engine being provisioned.
  depends_on = [
    google_vertex_ai_search_data_store.main,
    google_project_service_identity.discovery_engine_sa,
  ]

  # Preconditions to ensure valid configuration.
  lifecycle {
    precondition {
      condition     = !(var.solution_type == "SOLUTION_TYPE_CONVERSATION" && var.chat_engine_config == null)
      error_message = "The 'chat_engine_config' variable must be set when 'solution_type' is 'SOLUTION_TYPE_CONVERSATION'."
    }
    precondition {
      condition     = length(local.all_data_store_ids) > 0
      error_message = "At least one data store must be provided, either through the 'data_stores' variable or the 'existing_data_store_ids' variable."
    }
  }
}

# Creates one or more Data Stores based on the `var.data_stores` map.
# Each data store holds content to be indexed from a specific source.
resource "google_vertex_ai_search_data_store" "main" {
  # Iterate over the user-provided map of data store configurations.
  for_each = var.data_stores

  # The GCP project ID.
  project = var.project_id
  # The GCP location for the resource.
  location = var.location
  # The user-friendly name for the Data Store.
  display_name = each.value.display_name
  # The unique ID for the Data Store.
  data_store_id = each.value.data_store_id
  # Must match the solution type of the parent App.
  solution_types = [var.solution_type]
  # Specifies the type of content, e.g., 'CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT' for web pages or PDFs.
  content_config = each.value.content_config
  # Industry vertical can help optimize search results.
  industry_vertical = each.value.industry_vertical
}

# This locals block prepares the list of all data store IDs to be attached to the app.
# It combines the IDs of data stores created within this module with any pre-existing IDs provided by the user.
locals {
  created_data_store_ids = [for ds in google_vertex_ai_search_data_store.main : ds.data_store_id]
  all_data_store_ids     = tolist(toset(concat(local.created_data_store_ids, var.existing_data_store_ids)))
}
