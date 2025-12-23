# Terraform Vertex AI Search App Module

This module provisions a Vertex AI Search App, the top-level container for engines and data stores in Google Cloud Vertex AI Search. It supports creating both search and conversational applications, with options to create new data stores or attach existing ones.

## Usage

### Basic Search App

This example provisions a standard Vertex AI Search app with an enterprise-tier search engine and connects it to a pre-existing data store.

```hcl
module "vertex_ai_search_app" {
  source = "./" // Or a path to your module

  project_id                = "your-gcp-project-id"
  app_display_name          = "My Company Search"
  engine_id                 = "my-company-search-engine"
  solution_type             = "SOLUTION_TYPE_SEARCH"
  existing_data_store_ids   = ["my-existing-datastore-id_1"]

  search_engine_config = {
    search_tier    = "SEARCH_TIER_ENTERPRISE"
    search_add_ons = ["SEARCH_ADD_ON_LLM"]
  }
}
```

### Conversational App with a New Data Store

This example provisions a conversational app (chatbot) and creates a new data store to be used as its knowledge base.

```hcl
module "vertex_ai_chatbot" {
  source = "./" // Or a path to your module

  project_id       = "your-gcp-project-id"
  app_display_name = "My Helpdesk Chatbot"
  engine_id        = "my-helpdesk-chatbot-engine"
  solution_type    = "SOLUTION_TYPE_CONVERSATION"

  chat_engine_config = {
    business = "My Awesome Company"
  }

  data_stores = {
    main_kb = {
      data_store_id = "my-helpdesk-kb-ds"
      display_name  = "Main Knowledge Base"
    }
  }
}
```

## Requirements

The following requirements are needed to use this module.

### Software

-   Terraform `~> 1.3`
-   Terraform CLI

### APIs

The project must have the following APIs enabled:

-   `discoveryengine.googleapis.com`

## Providers

| Name | Version |
|------|---------|
| google | >= 5.25.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_service_identity.discovery_engine_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service_identity) | resource |
| [google_vertex_ai_search_app.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_search_app) | resource |
| [google_vertex_ai_search_data_store.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_search_data_store) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `app_display_name` | The display name of the Vertex AI Search App, which is the top-level container for engines and data stores. | `string` | `"my-vertex-ai-search-app"` | no |
| `chat_engine_config` | Configuration for a chat engine. This is required and only used when `solution_type` is `SOLUTION_TYPE_CONVERSATION`. `business` is the name of the company to use in the agent's responses. | `object({ business = string, default_language_code = optional(string), time_zone = optional(string) })` | `null` | no |
| `data_stores` | A map of Data Store configurations to create and attach to the engine. The keys of the map are logical names, and the values are the configuration objects. If empty, no new data stores will be created. | `map(object({ data_store_id = string, display_name = string, content_config = optional(string), industry_vertical = optional(string) }))` | `{}` | no |
| `engine_id` | The unique ID for the Engine. Must be a-z, 0-9, or hyphens, with a length of 1-40. | `string` | `"my-vertex-ai-search-engine"` | no |
| `existing_data_store_ids` | A list of pre-existing Data Store IDs to attach to the app. | `list(string)` | `[]` | no |
| `location` | The GCP location for the Vertex AI Search and Conversation resources. | `string` | `"global"` | no |
| `project_id` | The Google Cloud project ID where the resources will be created. | `string` | n/a | yes |
| `search_engine_config` | Configuration for a search engine. Only used when `solution_type` is `SOLUTION_TYPE_SEARCH`. `search_tier` can be `SEARCH_TIER_STANDARD` or `SEARCH_TIER_ENTERPRISE`. `search_add_ons` can include `SEARCH_ADD_ON_LLM`. | `object({ search_tier = optional(string), search_add_ons = optional(list(string)) })` | `{ search_tier = "SEARCH_TIER_STANDARD", search_add_ons = [] }` | no |
| `solution_type` | The solution type for the app and engine. Can be `SOLUTION_TYPE_SEARCH` for search applications or `SOLUTION_TYPE_CONVERSATION` for conversational AI applications. | `string` | `"SOLUTION_TYPE_SEARCH"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `app_name` | The full resource name of the created Vertex AI Search App. |
| `created_data_stores` | A map of the data stores created by this module, with their full resource names and IDs. |
| `engine_id` | The unique ID of the Engine. |
| `service_agent` | The service account email for the Vertex AI Search service agent. |
