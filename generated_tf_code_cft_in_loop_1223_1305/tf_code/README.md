```markdown
# Google Cloud Vertex AI Search and Conversation Module

This module provisions core resources for Google Cloud Vertex AI Search and Conversation. It simplifies the creation of a `Data Store` and, optionally, a `Chat Engine` for building search and conversational AI applications.

This module supports creating:
- A Data Store for `SOLUTION_TYPE_SEARCH`.
- A Data Store and a connected Chat Engine for `SOLUTION_TYPE_CHAT`.
- Data Stores for unstructured documents or structured data with a JSON schema.

## Compatibility
This module is meant for use with Terraform 1.3+ and is tested against the latest version of the Google Beta provider (`~> 5.31`).

## Usage

### Basic Search Data Store
The following example creates a simple Data Store configured for search with unstructured documents.

```hcl
module "vertex_ai_search_datastore" {
  source                 = "./"
  project_id             = "your-gcp-project-id"
  location               = "global"
  datastore_id           = "my-search-datastore"
  datastore_display_name = "My Company Search Data Store"
  solution_type          = "SOLUTION_TYPE_SEARCH"
  content_config         = "CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT"
}
```

### Chat Engine with Data Store
The following example creates a Data Store and a Chat Engine on top of it, configured for a conversational AI application.

```hcl
module "vertex_ai_chat_app" {
  source                 = "./"
  project_id             = "your-gcp-project-id"
  location               = "global"
  
  # Engine configuration
  display_name           = "My Company Chat App"
  engine_id              = "my-company-chat-engine"
  
  # Data Store configuration
  datastore_id           = "my-company-chat-datastore"
  datastore_display_name = "My Company Chat Data Store"
  
  # App Type configuration
  solution_type          = "SOLUTION_TYPE_CHAT"
  content_config         = "CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT"

  # Chat Engine specific configuration
  chat_engine_config = {
    agent_creation_config = {
      business              = "My Awesome Company Inc."
      default_language_code = "en"
      time_zone             = "America/Los_Angeles"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `chat_engine_config` | Configuration for a chat app. See the `variable "chat_engine_config"` block for the required object structure. | `object(...)` | `null` | Yes, when `solution_type` is `SOLUTION_TYPE_CHAT`. |
| `content_config` | The content configuration of the datastore. Valid values are `CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT` or `CONTENT_CONFIG_STRUCTURED_DATA`. | `string` | `null` | yes |
| `data_store_schema_id` | The unique ID for the schema. Used when `content_config` is `CONTENT_CONFIG_STRUCTURED_DATA`. | `string` | `"default-schema"` | no |
| `data_store_schema_json` | The JSON schema for the datastore as a string. | `string` | `null` | Yes, when `content_config` is `CONTENT_CONFIG_STRUCTURED_DATA`. |
| `datastore_display_name` | The human-readable display name of the datastore. | `string` | `null` | yes |
| `datastore_id` | A unique identifier for the datastore. Must be alphanumeric, may contain hyphens, and be up to 63 characters long. | `string` | `null` | yes |
| `display_name` | The base display name for the Vertex AI Engine. A suffix of '-engine' will be added automatically. | `string` | `null` | Yes, when `solution_type` is `SOLUTION_TYPE_CHAT`. |
| `engine_id` | A unique identifier for the engine (App). Must be alphanumeric, may contain hyphens, and be up to 63 characters long. | `string` | `null` | Yes, when `solution_type` is `SOLUTION_TYPE_CHAT`. |
| `industry_vertical` | The industry vertical that the datastore registers. For example, `GENERIC`, `MEDIA`, `HEALTHCARE`. | `string` | `"GENERIC"` | no |
| `location` | The location for the Vertex AI Search and Conversation resources. Can be `global`, `us`, or `eu`. | `string` | `"global"` | no |
| `project_id` | The ID of the project in which to create the resources. If not provided, the provider project is used. | `string` | `null` | no |
| `search_engine_config` | **DEPRECATED**: This variable is no longer supported and must be set to `null`. Search capabilities are configured directly on the data store or via the GCP console. | `object(...)` | `null` | no |
| `solution_type` | The solution type for the app. Valid values are `SOLUTION_TYPE_SEARCH` or `SOLUTION_TYPE_CHAT`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `data_store_name` | The full resource name of the created Datastore. |
| `datastore_id` | The unique ID of the created datastore. |
| `engine_id` | The unique ID of the created Engine. This is only applicable for `SOLUTION_TYPE_CHAT`. |
| `engine_name` | The full resource name of the created Engine. This is only applicable for `SOLUTION_TYPE_CHAT`. |

## Requirements

### Terraform
- Terraform `1.3` or newer.

### Providers
- Google Provider (`google-beta`) `~> 5.31`

### Google Cloud APIs
The following APIs must be enabled in the project where this module will be deployed:
- `discoveryengine.googleapis.com` (Vertex AI Search and Conversation API)

### IAM Roles
The service account or user running Terraform must have the following roles on the project:
- `roles/discoveryengine.admin`
```
