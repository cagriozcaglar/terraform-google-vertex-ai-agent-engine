locals {
  # data_store_ids is a list of data store IDs to be associated with the engine, derived from the keys of the input variable map.
  data_store_ids = keys(var.data_stores)
  # engine_unique_id is a sanitized unique ID for the engine, derived from the display name.
  # It must be 4-63 characters, start with a letter, and contain only lowercase letters, numbers, and hyphens.
  engine_unique_id = "engine-${substr(trim(replace(lower(var.display_name), "[^a-z0-9-]+", "-"), "-"), 0, 56)}"
}

# Enables the Discovery Engine API required for Vertex AI Search and Conversation.
resource "google_project_service" "discovery_engine_api" {
  # Controls the automatic enabling of the API. Set to 1 to enable, 0 to skip.
  count = var.enable_apis ? 1 : 0

  # The project ID to enable the API in.
  project = var.project_id
  # The service to enable, in this case 'discoveryengine.googleapis.com'.
  service = "discoveryengine.googleapis.com"
  # If true, the API will not be disabled when the resource is destroyed.
  disable_on_destroy = false
}

# The Data Stores, which point to the knowledge sources.
resource "google_discovery_engine_data_store" "this" {
  # Creates a data store for each item in the data_stores variable map.
  for_each = var.data_stores

  # The project ID to deploy the Data Store resources in.
  project = var.project_id
  # The location for the Data Store. Must be the same as the app.
  location = var.location
  # The unique ID of the data store, taken from the map key.
  data_store_id = each.key
  # The display name of the data store.
  display_name = each.value.display_name
  # The industry vertical for the data store.
  industry_vertical = var.industry_vertical
  # The content configuration for the data store.
  content_config = each.value.content_config
  # The solution types that the data store can be used for.
  solution_types = [var.solution_type]

  # Explicitly depend on the API being enabled before creating data stores.
  depends_on = [google_project_service.discovery_engine_api]
}

# The Discovery Engine App for SEARCH or CHAT solutions.
# This resource replaces the deprecated google_discovery_engine_engine and google_discovery_engine_chat_engine resources.
resource "google_discovery_engine_app" "this" {
  # The project ID to deploy the Discovery Engine App in.
  project = var.project_id
  # The location for the Discovery Engine App.
  location = var.location
  # The collection ID for the App.
  collection_id = var.collection_id
  # The unique ID for the App. Must be 4-63 characters, start with a letter, and contain only lowercase letters, numbers, and hyphens.
  engine_id = local.engine_unique_id
  # The human-readable display name for the App.
  display_name = var.display_name
  # The list of data store IDs to associate with this App.
  data_store_ids = local.data_store_ids
  # The solution type for the App, either SEARCH or CHAT.
  solution_type = var.solution_type

  # The configuration for a search engine.
  dynamic "search_engine_config" {
    # This block is only created if the solution type is SEARCH.
    for_each = var.solution_type == "SOLUTION_TYPE_SEARCH" ? [1] : []

    content {
      # The search tier for a SEARCH solution.
      search_tier = var.search_tier
      # A list of search add-ons for a SEARCH solution.
      search_add_ons = var.search_add_ons
    }
  }

  # The configuration for a chat engine.
  dynamic "chat_engine_config" {
    # This block is only created if the solution type is CHAT.
    for_each = var.solution_type == "SOLUTION_TYPE_CHAT" ? [1] : []

    content {
      # The agent engine configuration.
      agent_creation_config {
        # The display name for the business in the agent.
        business = var.chat_app_business
        # The default language code of the agent.
        default_language_code = var.chat_app_language_code
        # The timezone of the agent.
        time_zone = var.chat_app_time_zone
      }
    }
  }

  lifecycle {
    # Preconditions to check before creating the resource.
    precondition {
      # This condition ensures that the language code is provided for CHAT solutions.
      condition     = var.solution_type != "SOLUTION_TYPE_CHAT" || var.chat_app_language_code != null
      # The error message to display if the condition is false.
      error_message = "The 'chat_app_language_code' variable must be set when 'solution_type' is 'SOLUTION_TYPE_CHAT'."
    }
  }

  # Explicitly depend on the data stores and API service.
  depends_on = [
    # API must be enabled before App creation.
    google_project_service.discovery_engine_api,
    # Data stores must exist before being attached to the App.
    google_discovery_engine_data_store.this
  ]
}
