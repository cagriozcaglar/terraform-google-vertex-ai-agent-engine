# A check to ensure chat engine configuration is provided for chat solutions.
check "chat_engine_config_is_set" {
  # This assertion fails if the solution type is chat but no chat engine config is provided.
  assert {
    condition     = var.solution_type == null || var.solution_type != "SOLUTION_TYPE_CHAT" || var.chat_engine_config != null
    error_message = "The 'chat_engine_config' variable must be set when 'solution_type' is 'SOLUTION_TYPE_CHAT'."
  }
}

# A check to ensure a schema is provided for structured data stores.
check "data_store_schema_is_set" {
  # This assertion fails if the content config is for structured data but no schema is provided.
  assert {
    condition     = var.content_config == null || var.content_config != "CONTENT_CONFIG_STRUCTURED_DATA" || var.data_store_schema_json != null
    error_message = "The 'data_store_schema_json' variable must be set when 'content_config' is 'CONTENT_CONFIG_STRUCTURED_DATA'."
  }
}

# A check to ensure display_name is provided for chat solutions.
check "display_name_is_set_for_chat" {
  # This assertion fails if the solution type is chat but no display_name is provided.
  assert {
    condition     = var.solution_type == null || var.solution_type != "SOLUTION_TYPE_CHAT" || var.display_name != null
    error_message = "The 'display_name' variable must be set when 'solution_type' is 'SOLUTION_TYPE_CHAT'."
  }
}

# A check to ensure engine_id is provided for chat solutions.
check "engine_id_is_set_for_chat" {
  # This assertion fails if the solution type is chat but no engine_id is provided.
  assert {
    condition     = var.solution_type == null || var.solution_type != "SOLUTION_TYPE_CHAT" || var.engine_id != null
    error_message = "The 'engine_id' variable must be set when 'solution_type' is 'SOLUTION_TYPE_CHAT'."
  }
}

# A check to ensure the now-unsupported search_engine_config is not used.
check "search_engine_config_is_unsupported" {
  # This assertion fails if the deprecated search_engine_config variable is used.
  assert {
    condition     = var.search_engine_config == null
    error_message = "The 'search_engine_config' variable is deprecated and no longer supported. Please remove it from your configuration. Search capabilities are now configured directly on the data store or via the GCP console."
  }
}

# Local variables for consistent naming and resource definitions.
locals {
  # Defines the collection ID to be used.
  collection_id = "default_collection"
  # A flag to enable/disable resource creation based on required variables.
  enabled = var.datastore_id != null && var.datastore_display_name != null && var.content_config != null
  # Appends '-engine' to the provided display name for the Engine resource.
  engine_display_name = var.display_name != null ? "${var.display_name}-engine" : null
}

# The Chat Engine resource, which provides chat functionality over one or more datastores.
# This resource is created only if the module is enabled and solution_type is 'SOLUTION_TYPE_CHAT'.
resource "google_discovery_engine_chat_engine" "main" {
  # Creates one instance if enabled and the solution type is for chat, otherwise zero.
  count = local.enabled && var.solution_type == "SOLUTION_TYPE_CHAT" ? 1 : 0

  # The provider to use for this resource.
  provider = google-beta
  # The project ID where the Engine will be created. If not provided, the provider project is used.
  project = var.project_id
  # The location of the Engine.
  location = var.location
  # The collection ID.
  collection_id = local.collection_id
  # A unique identifier for the Engine.
  engine_id = var.engine_id
  # The human-readable display name for the Engine.
  display_name = local.engine_display_name
  # The data stores associated with this engine.
  data_store_ids = [google_discovery_engine_data_store.main[0].data_store_id]
  # The industry vertical that the chat engine registers.
  industry_vertical = var.industry_vertical

  # The configuration of the chat engine.
  chat_engine_config {
    # The configuration of the agent creator.
    agent_creation_config {
      # The business name of the agent.
      business = var.chat_engine_config.agent_creation_config.business
      # The default language of the agent.
      default_language_code = var.chat_engine_config.agent_creation_config.default_language_code
      # The time zone of the agent, e.g., 'America/Los_Angeles'.
      time_zone = var.chat_engine_config.agent_creation_config.time_zone
    }
  }
}

# The Data Store resource, which holds the indexed data from a source.
resource "google_discovery_engine_data_store" "main" {
  # Creates one instance if the module is enabled, otherwise zero.
  count = local.enabled ? 1 : 0

  # The provider to use for this resource.
  provider = google-beta
  # The project ID where the Data Store will be created. If not provided, the provider project is used.
  project = var.project_id
  # The location of the Data Store.
  location = var.location
  # A unique identifier for the Data Store.
  data_store_id = var.datastore_id
  # The human-readable display name for the Data Store.
  display_name = var.datastore_display_name
  # The industry vertical of the data store.
  industry_vertical = var.industry_vertical
  # The solution types that the data store is compatible with.
  solution_types = var.solution_type != null ? [var.solution_type] : []
  # The content configuration of the data store.
  content_config = var.content_config
  # This field must be set to `false` if the data store is used for generic search.
  create_advanced_site_search = false
}

# The Schema for a structured data Data Store.
# This resource is created only if the module is enabled and content_config is 'CONTENT_CONFIG_STRUCTURED_DATA'.
resource "google_discovery_engine_schema" "structured_data_schema" {
  # Creates one instance if enabled and content config is for structured data, otherwise zero.
  count = local.enabled && var.content_config == "CONTENT_CONFIG_STRUCTURED_DATA" ? 1 : 0

  # The provider to use for this resource.
  provider = google-beta
  # The project ID where the Schema will be created. If not provided, the provider project is used.
  project = var.project_id
  # The location of the parent Data Store.
  location = google_discovery_engine_data_store.main[0].location
  # The ID of the parent Data Store.
  data_store_id = google_discovery_engine_data_store.main[0].data_store_id
  # The unique identifier for the Schema.
  schema_id = var.data_store_schema_id
  # The JSON representation of the schema.
  json_schema = var.data_store_schema_json
}
