# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# ## Inputs
#
# | Name | Description | Type | Default | Required |
# |------|-------------|------|---------|:--------:|
# | app\_display\_name | The display name of the Vertex AI Search App, which is the top-level container for engines and data stores. | `string` | `"my-vertex-ai-search-app"` | no |
# | chat\_engine\_config | Configuration for a chat engine. This is required and only used when `solution_type` is `SOLUTION_TYPE_CONVERSATION`. `business` is the name of the company to use in the agent's responses. | <pre>object({<br>    business              = string<br>    default_language_code = optional(string, "en")<br>    time_zone             = optional(string, "America/Los_Angeles")<br>  })</pre> | `null` | no |
# | data\_stores | A map of Data Store configurations to create and attach to the engine. The keys of the map are logical names, and the values are the configuration objects. If empty, no new data stores will be created. | <pre>map(object({<br>    data_store_id   = string<br>    display_name    = string<br>    content_config  = optional(string, "CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT")<br>    industry_vertical = optional(string, "INDUSTRY_VERTICAL_GENERIC")<br>  }))</pre> | `{}` | no |
# | engine\_id | The unique ID for the Engine. Must be a-z, 0-9, or hyphens, with a length of 1-40. | `string` | `"my-vertex-ai-search-engine"` | no |
# | existing\_data\_store\_ids | A list of pre-existing Data Store IDs to attach to the app. | `list(string)` | `[]` | no |
# | location | The GCP location for the Vertex AI Search and Conversation resources. | `string` | `"global"` | no |
# | project\_id | The Google Cloud project ID where the resources will be created. | `string` | n/a | yes |
# | search\_engine\_config | Configuration for a search engine. Only used when `solution_type` is `SOLUTION_TYPE_SEARCH`. `search_tier` can be `SEARCH_TIER_STANDARD` or `SEARCH_TIER_ENTERPRISE`. `search_add_ons` can include `SEARCH_ADD_ON_LLM`. | <pre>object({<br>    search_tier    = optional(string, "SEARCH_TIER_STANDARD")<br>    search_add_ons = optional(list(string), [])<br>  })</pre> | <pre>{<br>  "search_add_ons": [],<br>  "search_tier": "SEARCH_TIER_STANDARD"<br>}</pre> | no |
# | solution\_type | The solution type for the app and engine. Can be `SOLUTION_TYPE_SEARCH` for search applications or `SOLUTION_TYPE_CONVERSATION` for conversational AI applications. | `string` | `"SOLUTION_TYPE_SEARCH"` | no |
#
# ## Outputs
#
# | Name | Description |
# |------|-------------|
# | app\_name | The full resource name of the created Vertex AI Search App. |
# | created\_data\_stores | A map of the data stores created by this module, with their full resource names and IDs. |
# | engine\_id | The unique ID of the Engine. |
# | service\_agent | The service account email for the Vertex AI Search service agent. |
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
variable "app_display_name" {
  description = "The display name of the Vertex AI Search App, which is the top-level container for engines and data stores."
  type        = string
  default     = "my-vertex-ai-search-app"
}

variable "chat_engine_config" {
  description = "Configuration for a chat engine. This is required and only used when `solution_type` is `SOLUTION_TYPE_CONVERSATION`. `business` is the name of the company to use in the agent's responses."
  type = object({
    business              = string
    default_language_code = optional(string, "en")
    time_zone             = optional(string, "America/Los_Angeles")
  })
  default = null
}

variable "data_stores" {
  description = "A map of Data Store configurations to create and attach to the engine. The keys of the map are logical names, and the values are the configuration objects. If empty, no new data stores will be created."
  type = map(object({
    data_store_id     = string
    display_name      = string
    content_config    = optional(string, "CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT")
    industry_vertical = optional(string, "INDUSTRY_VERTICAL_GENERIC")
  }))
  default = {}
}

variable "engine_id" {
  description = "The unique ID for the Engine. Must be a-z, 0-9, or hyphens, with a length of 1-40."
  type        = string
  default     = "my-vertex-ai-search-engine"
}

variable "existing_data_store_ids" {
  description = "A list of pre-existing Data Store IDs to attach to the app."
  type        = list(string)
  default     = []
}

variable "location" {
  description = "The GCP location for the Vertex AI Search and Conversation resources."
  type        = string
  default     = "global"
}

variable "project_id" {
  description = "The Google Cloud project ID where the resources will be created."
  type        = string
}

variable "search_engine_config" {
  description = "Configuration for a search engine. Only used when `solution_type` is `SOLUTION_TYPE_SEARCH`. `search_tier` can be `SEARCH_TIER_STANDARD` or `SEARCH_TIER_ENTERPRISE`. `search_add_ons` can include `SEARCH_ADD_ON_LLM`."
  type = object({
    search_tier    = optional(string, "SEARCH_TIER_STANDARD")
    search_add_ons = optional(list(string), [])
  })
  default = {
    search_tier    = "SEARCH_TIER_STANDARD"
    search_add_ons = []
  }
}

variable "solution_type" {
  description = "The solution type for the app and engine. Can be `SOLUTION_TYPE_SEARCH` for search applications or `SOLUTION_TYPE_CONVERSATION` for conversational AI applications."
  type        = string
  default     = "SOLUTION_TYPE_SEARCH"

  validation {
    condition     = contains(["SOLUTION_TYPE_SEARCH", "SOLUTION_TYPE_CONVERSATION"], var.solution_type)
    error_message = "The solution_type must be either 'SOLUTION_TYPE_SEARCH' or 'SOLUTION_TYPE_CONVERSATION'."
  }
}
