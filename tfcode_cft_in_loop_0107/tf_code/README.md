# Google Cloud Vertex AI Search and Conversation Module

This module handles the deployment of a Google Cloud Vertex AI Search and Conversation App (formerly Discovery Engine), its associated Data Stores, and the enabling of the necessary API. It simplifies the setup of either a Search or a Chat solution by managing the underlying App and Data Store resources.

## Usage

Below are examples of how to use the module for both `SEARCH` and `CHAT` solution types.

### Search App Example

```hcl
module "discovery_engine_search_app" {
  source = "./path/to/module"

  project_id   = "your-gcp-project-id"
  location     = "global"
  display_name = "my-company-search-engine"

  solution_type = "SOLUTION_TYPE_SEARCH"
  search_tier   = "SEARCH_TIER_ENTERPRISE"
  search_add_ons = ["SEARCH_ADD_ON_LLM"]

  data_stores = {
    "website-public" = {
      display_name   = "Public Website Content"
      content_config = "NO_SCHEMA"
    }
  }
}
```

### Chat App Example

```hcl
module "discovery_engine_chat_app" {
  source = "./path/to/module"

  project_id             = "your-gcp-project-id"
  location               = "us" # Multi-regional location
  display_name           = "my-support-chatbot"

  solution_type          = "SOLUTION_TYPE_CHAT"
  chat_app_language_code = "en"
  chat_app_business      = "My Awesome Company Inc."
  chat_app_time_zone     = "America/New_York"

  data_stores = {
    "internal-knowledge-base" = {
      display_name   = "Internal KB Documents"
      content_config = "NO_SCHEMA"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chat\_app\_business | The display name for the business in the CHAT solution's agent. This is used in agent responses. | `string` | `""` | no |
| chat\_app\_language\_code | The default language code to use for the CHAT solution's agent (e.g., 'en'). Required if solution\_type is 'SOLUTION\_TYPE\_CHAT'. | `string` | `null` | no |
| chat\_app\_time\_zone | The timezone of the CHAT solution's agent (e.g., 'America/Los\_Angeles'). Required for 'SOLUTION\_TYPE\_CHAT'. | `string` | `"America/Los_Angeles"` | no |
| collection\_id | The collection ID. For now, only 'default\_collection' is supported. | `string` | `"default_collection"` | no |
| data\_stores | A map of data stores to create and connect to the engine. The key is the 'data\_store\_id'. Each value is an object with a 'display\_name' and an optional 'content\_config' (defaults to 'NO\_SCHEMA'). Note Data must be imported into the data store after creation. | <pre>map(object({<br>    display_name   = string<br>    content_config = optional(string, "NO_SCHEMA")<br>  }))</pre> | <pre>{<br>  "default-data-store" = {<br>    display_name   = "Default Data Store"<br>    content_config = "NO_SCHEMA"<br>  }<br>}</pre> | no |
| display\_name | The base display name for the Discovery Engine App. | `string` | `"discovery-engine-app"` | no |
| enable\_apis | A boolean to control the automatic enabling of the 'discoveryengine.googleapis.com' API. | `bool` | `true` | no |
| industry\_vertical | The industry vertical for the data stores. | `string` | `"GENERIC"` | no |
| location | The location for the Discovery Engine App and Data Stores. Can be global, multi-regional (e.g., 'eu', 'us'), or regional. Note - Data Stores for an app must be in the same location. | `string` | n/a | yes |
| project\_id | The project ID to deploy the Discovery Engine resources in. | `string` | n/a | yes |
| search\_add\_ons | A list of search add-ons for a SEARCH solution. e.g., ['SEARCH\_ADD\_ON\_LLM'] | `list(string)` | `[]` | no |
| search\_tier | The search tier for a SEARCH solution. Can be 'SEARCH\_TIER\_STANDARD' or 'SEARCH\_TIER\_ENTERPRISE'. | `string` | `"SEARCH_TIER_STANDARD"` | no |
| solution\_type | The solution type for the engine. Can be 'SOLUTION\_TYPE\_SEARCH' or 'SOLUTION\_TYPE\_CHAT'. | `string` | `"SOLUTION_TYPE_SEARCH"` | no |

## Outputs

| Name | Description |
|------|-------------|
| data\_store\_names | A map of the created Data Store resource names, keyed by the logical name provided in the input variable. |
| data\_stores | A map of the created Discovery Engine Data Store resource objects, keyed by the logical name provided in the input variable. |
| engine | The full Discovery Engine App resource object. |
| engine\_id | The unique ID of the Discovery Engine App. |
| engine\_name | The resource name of the created Discovery Engine App. |

## Requirements

These sections describe requirements for using this module.

### Terraform

| Name | Version |
|------|---------|
| Terraform | >= 1.3 |
| anyscale/google | >= 5.23.0 |

### APIs

A project with the following APIs enabled is required:

- `discoveryengine.googleapis.com`: Vertex AI Search and Conversation API
