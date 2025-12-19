# Terraform Google Vertex AI Search Chat Engine Module

This module creates a Google Cloud Vertex AI Search Chat Engine and an associated Discovery Engine Data Store. This combination allows you to build conversational AI applications (like chatbots and virtual agents) that are grounded in your own data.

The module provisions the following core resources:
- A **Discovery Engine Data Store** to hold the knowledge base for your application.
- A **Vertex AI Search Chat Engine** which orchestrates conversations and interacts with the underlying Large Language Model (LLM).

## Prerequisites

Before you can use this module, you must have the following:
1.  A Google Cloud project.
2.  The [Discovery Engine API](https://console.cloud.google.com/apis/library/discoveryengine.googleapis.com) enabled in your project.
3.  A service account with the necessary permissions (e.g., `roles/discovery.admin`) to create and manage Discovery Engine resources.

This module uses the `google-beta` provider, which is required for managing Vertex AI Search and Discovery Engine resources.

## Usage

Here is a basic example of how to use the module:

```hcl
module "vertex_ai_search_chat_engine" {
  source = "./" // or a git source like "github.com/your-org/your-repo//path/to/module"

  project_id              = "your-gcp-project-id"
  location                = "global"
  agent_display_name      = "My Support Agent"
  data_store_display_name = "Company Knowledge Base"
  company_name            = "My Awesome Company Inc."
  time_zone               = "America/New_York"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_agent_display_name"></a> [agent\_display\_name](#input\_agent\_display\_name) | The human-readable display name for the Vertex AI Search Chat Engine. | `string` | `"My Vertex AI Chat Engine"` |
| <a name="input_chat_engine_id"></a> [chat\_engine\_id](#input\_chat\_engine\_id) | A unique identifier for the Chat Engine. Must be alphanumeric and up to 40 characters long. If not provided, a random one will be generated. | `string` | `null` |
| <a name="input_company_name"></a> [company\_name](#input\_company\_name) | The name of the company to use in agent responses. | `string` | `null` |
| <a name="input_data_store_content_config"></a> [data\_store\_content\_config](#input\_data\_store\_content\_config) | The content configuration for the data store. Specifies how data is provided to the data store. Allowed values: 'NO\_CONTENT', 'CONTENT\_REQUIRED', 'PUBLIC\_WEBSITE'. | `string` | `"CONTENT_REQUIRED"` |
| <a name="input_data_store_display_name"></a> [data\_store\_display\_name](#input\_data\_store\_display\_name) | The human-readable display name for the data store that grounds the agent. | `string` | `"My Vertex AI Chat Data Store"` |
| <a name="input_data_store_id"></a> [data\_store\_id](#input\_data\_store\_id) | A unique identifier for the data store. Must be alphanumeric and up to 60 characters long. If not provided, a random one will be generated. | `string` | `null` |
| <a name="input_default_language_code"></a> [default\_language\_code](#input\_default\_language\_code) | The default language code for the agent, e.g., 'en'. | `string` | `"en"` |
| <a name="input_location"></a> [location](#input\_location) | The GCP location for the app and data store. Must be one of 'global', 'us', 'eu'. | `string` | `"global"` |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resources will be created. If not provided, the provider project will be used. | `string` | `null` |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | The time zone of the agent, e.g., 'America/Los\_Angeles'. | `string` | `"America/Los_Angeles"` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chat_engine_id"></a> [chat\_engine\_id](#output\_chat\_engine\_id) | The unique identifier of the created Chat Engine. |
| <a name="output_chat_engine_name"></a> [chat\_engine\_name](#output\_chat\_engine\_name) | The full resource name of the created Chat Engine, in the format projects/{project}/locations/{location}/collections/{collection\_id}/engines/{engine\_id}. |
| <a name="output_data_store_id"></a> [data\_store\_id](#output\_data\_store\_id) | The unique identifier of the created Discovery Engine Data Store. |
| <a name="output_data_store_name"></a> [data\_store\_name](#output\_data\_store\_name) | The full resource name of the created Discovery Engine Data Store, in the format projects/{project}/locations/{location}/collections/default\_collection/dataStores/{data\_store\_id}. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

### Terraform

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

### Providers

| Name | Version |
|------|---------|
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.36.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.0 |
