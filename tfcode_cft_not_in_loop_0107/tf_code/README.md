# Terraform Module for Google Cloud Dialogflow CX Agent

This module provisions a Google Cloud Dialogflow CX Agent, which serves as the foundation for building advanced conversational AI applications, often referred to as Vertex AI Agents.

This module allows for the configuration of the core agent, and optionally supports the creation of associated resources such as:
-   **Tools**: Integrate with external services and APIs using an OpenAPI specification.
-   **Discovery Engine Datastore**: Create a knowledge base for Retrieval-Augmented Generation (RAG) and generative AI features.

## Usage

### Basic Agent Creation

The following example shows how to create a simple Dialogflow CX Agent.

```hcl
module "dialogflow_cx_agent" {
  source                = "PATH_TO_MODULE" // e.g., git::https://github.com/your-org/your-repo.git//modules/dialogflow-cx-agent
  project_id            = "your-gcp-project-id"
  location              = "us-central1"
  display_name          = "My Simple Agent"
  time_zone             = "America/New_York"
  default_language_code = "en"
  description           = "A basic agent created with Terraform."
}
```

### Advanced Agent with Tools and a Datastore

The following example demonstrates a more complex setup that includes an agent with a tool defined by an OpenAPI spec and a Discovery Engine datastore for knowledge retrieval.

```hcl
module "dialogflow_cx_agent_advanced" {
  source       = "PATH_TO_MODULE"
  project_id   = "your-gcp-project-id"
  location     = "us-central1"
  display_name = "My Advanced Agent"
  time_zone    = "America/Los_Angeles"
  description  = "An agent with tools and a datastore for RAG."

  # Add a tool to the agent from an OpenAPI spec file
  tools = {
    weather_tool = {
      display_name        = "Weather API"
      description         = "Gets the current weather for a specified location."
      openapi_spec_schema = file("${path.module}/specs/weather_api.yaml")
    }
  }

  # Create a Discovery Engine datastore to act as a knowledge base
  datastore_location = "global"
  datastore_config = {
    data_store_id     = "my-agent-knowledge-base-1"
    display_name      = "My Agent Knowledge Base"
    industry_vertical = "GENERIC"
    solution_types    = ["SOLUTION_TYPE_SEARCH"]
    content_config    = "CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT"
  }

  # Enable generative features by linking the datastore to the agent
  gen_app_builder_settings = {
    engine = "projects/${var.project_id}/locations/global/collections/default_collection/dataStores/my-agent-knowledge-base-1"
  }
}
```

## Requirements

Before this module can be used on a project, the following APIs must be enabled:
-   Dialogflow API: `dialogflow.googleapis.com`
-   Discovery Engine API: `discoveryengine.googleapis.com`
-   Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

The service account or user running Terraform will need the following IAM roles:
-   `roles/dialogflow.admin`: To create and manage Dialogflow CX agents and tools.
-   `roles/discoveryengine.admin`: To create and manage Discovery Engine datastores.
-   `roles/resourcemanager.projectIamAdmin`: To create the service identity for Discovery Engine.
-   `roles/serviceusage.serviceUsageAdmin`: To enable the required APIs.

### Software

-   [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
-   [Terraform Provider for Google](https://github.com/hashicorp/terraform-provider-google) >= 5.15.0
-   [Terraform Provider for Google Beta](https://github.com/hashicorp/terraform-provider-google-beta) >= 5.15.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The ID of the Google Cloud project in which to provision the resources. | `string` | `null` | yes |
| `location` | The location for the Dialogflow CX Agent. This is the primary region for the agent and its associated tools. | `string` | `null` | yes |
| `display_name` | The human-readable display name for the Dialogflow CX Agent. | `string` | `null` | yes |
| `time_zone` | The time zone of the agent from the IANA Time Zone Database. For example, America/New\_York, Europe/Paris. | `string` | `null` | yes |
| `default_language_code` | The default language of the agent as a language tag (e.g., 'en', 'en-US'). | `string` | `"en"` | no |
| `description` | The description of the agent. The maximum length is 500 characters. | `string` | `null` | no |
| `avatar_uri` | The URI of the agent's avatar. Avatars are used throughout the Dialogflow console and in the self-hosted Web Demo integration. | `string` | `null` | no |
| `enable_stackdriver_logging` | Determines whether Stackdriver logging is enabled for the agent. | `bool` | `true` | no |
| `enable_spell_correction` | Indicates if automatic spell correction is enabled for this agent. | `bool` | `false` | no |
| `advanced_settings` | Hierarchical advanced settings for this agent. The structure of this object must follow the schema for the 'advancedSettings' argument in the google\_dialogflow\_cx\_agent resource. For example, to configure audio export: `{ audio_export_gcs_destination = { uri = 'gs://your-bucket/audio/' } }` | `any` | `null` | no |
| `gen_app_builder_settings` | Settings for Generative App Builder. If this is not set, generative features will be disabled. To enable, set to an object like `{ engine = 'projects/your-project-id/locations/global/collections/default_collection/dataStores/your-datastore-id' }`. | `any` | `null` | no |
| `text_to_speech_settings` | Settings for text-to-speech. This object must conform to the 'textToSpeechSettings' argument schema in the google\_dialogflow\_cx\_agent resource. For example: `{ synthesize_speech_configs = jsonencode({'en-US': {'voice': {'name': 'en-US-Wavenet-D'}}}) }`. | `any` | `null` | no |
| `speech_to_text_settings` | Settings for speech-to-text. This object must conform to the 'speechToTextSettings' argument schema in the google\_dialogflow\_cx\_agent resource. For example: `{ enable_speech_adaptation = true }`. | `any` | `null` | no |
| `tools` | A map of tool configurations to create for the agent. The key of the map is a logical name used for referencing the tool. | <pre>map(object({<br>    display_name        = string<br>    description         = optional(string)<br>    openapi_spec_schema = string<br>  }))</pre> | `{}` | no |
| `datastore_config` | Configuration for a Discovery Engine Datastore to be created as a knowledge base for the agent. If null, no datastore is created. | <pre>object({<br>    data_store_id     = string<br>    display_name      = string<br>    industry_vertical = string<br>    solution_types    = list(string)<br>    content_config    = string<br>  })</pre> | `null` | no |
| `datastore_location` | The location for the Discovery Engine Datastore. Can be 'global' or a multi-regional location like 'us' or 'eu'. | `string` | `"global"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `agent_id` | The unique identifier of the created Dialogflow CX Agent. |
| `agent_name` | The full resource name of the created Dialogflow CX Agent. |
| `agent_start_flow` | The name of the start flow of the created agent. |
| `tools` | A map of the created tools, where the key is the logical name and the value is the tool's full resource name. |
| `datastore_id` | The unique identifier of the created Discovery Engine Datastore. This will be null if no datastore was created. |
| `datastore_name` | The full resource name of the created Discovery Engine Datastore. This will be null if no datastore was created. |
| `datastore_service_identity` | The email of the service account created for the Discovery Engine Datastore. This will be null if no datastore was created. |
