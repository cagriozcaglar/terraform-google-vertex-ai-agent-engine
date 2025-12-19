# This module creates a Google Cloud Vertex AI Search Chat Engine and an associated Discovery Engine Data Store.
# The Chat Engine is designed for conversational AI applications (chatbots, support agents) and can be grounded
# in your own data by populating the data store.
#
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

data "google_client_config" "current" {}

locals {
  # Use the user-provided ID if it exists, otherwise generate a random one.
  data_store_id  = var.data_store_id != null ? var.data_store_id : "ds-${random_id.suffix.hex}"
  chat_engine_id = var.chat_engine_id != null ? var.chat_engine_id : "chat-${random_id.suffix.hex}"
  project_id     = var.project_id == null ? data.google_client_config.current.project : var.project_id
}

# Provides a random suffix for resource names, if not provided by the user.
resource "random_id" "suffix" {
  # The number of random bytes to generate.
  byte_length = 4
}

# The Data Store resource holds the knowledge base for the agent.
# It can be populated with unstructured documents (PDFs, HTML), website content, or structured data.
resource "google_discovery_engine_data_store" "main" {
  # Specifies the beta provider. This is required as Discovery Engine resources are in beta.
  provider = google-beta

  # The project ID where the data store will be created.
  project = local.project_id
  # The location for the data store, which must match the app's location.
  location = var.location
  # The user-provided or randomly generated unique ID for this data store.
  data_store_id = local.data_store_id
  # A human-readable name for the data store.
  display_name = var.data_store_display_name
  # The industry vertical of the data store. GENERIC is suitable for most use cases.
  industry_vertical = "GENERIC"
  # The intended solutions for the data store. CHAT and SEARCH are common for agent use cases.
  solution_types = ["SOLUTION_TYPE_SEARCH", "SOLUTION_TYPE_CHAT"]
  # Specifies the type of content this data store will hold.
  content_config = var.data_store_content_config
}

# The Vertex AI Search Chat Engine resource, which orchestrates conversations
# and interacts with the underlying Large Language Model (LLM).
# This resource replaces the deprecated `google_discovery_engine_app` for chat solutions.
resource "google_discovery_engine_chat_engine" "main" {
  # Specifies the beta provider. This is required as Discovery Engine resources are in beta.
  provider = google-beta

  # The project ID where the chat engine will be created.
  project = local.project_id
  # The location for the chat engine. Note that available models may vary by location.
  location = var.location
  # The collection ID. 'default_collection' is used for all new resources.
  collection_id = "default_collection"
  # The user-provided or randomly generated unique ID for this chat engine.
  engine_id = local.chat_engine_id
  # A human-readable name for the chat engine.
  display_name = var.agent_display_name
  # Connects the chat engine to the data store(s) for grounding.
  data_store_ids = [google_discovery_engine_data_store.main.data_store_id]

  # Configuration for the chat engine's behavior.
  chat_engine_config {
    agent_creation_config {
      # The name of the company or business, used to personalize responses.
      business = var.company_name
      # The default language code for the agent.
      default_language_code = var.default_language_code
      # The time zone for the agent.
      time_zone = var.time_zone
    }
  }

  # Common configuration for the engine.
  common_config {
    # The name of the company, used across the engine's configuration.
    company_name = var.company_name
  }
}
