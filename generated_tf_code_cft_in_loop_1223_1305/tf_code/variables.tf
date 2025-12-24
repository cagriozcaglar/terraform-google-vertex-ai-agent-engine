# Configuration for a chat app.
variable "chat_engine_config" {
  description = "Configuration for a chat app. Required when `solution_type` is `SOLUTION_TYPE_CHAT`."
  type = object({
    agent_creation_config = object({
      business              = string
      default_language_code = string
      time_zone             = string
    })
  })
  default  = null
  nullable = true
}

# The content configuration of the datastore.
variable "content_config" {
  description = "The content configuration of the datastore. Valid values are `CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT` or `CONTENT_CONFIG_STRUCTURED_DATA`."
  type        = string
  default     = null

  validation {
    condition     = var.content_config == null ? true : contains(["CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT", "CONTENT_CONFIG_STRUCTURED_DATA"], var.content_config)
    error_message = "Allowed values for content_config are CONTENT_CONFIG_UNSTRUCTURED_DOCUMENT or CONTENT_CONFIG_STRUCTURED_DATA."
  }
}

# The ID for the datastore schema.
variable "data_store_schema_id" {
  description = "The unique ID for the schema. Used when `content_config` is `CONTENT_CONFIG_STRUCTURED_DATA`. Defaults to `default-schema`."
  type        = string
  default     = "default-schema"
}

# The JSON schema for the datastore.
variable "data_store_schema_json" {
  description = "The JSON schema for the datastore as a string. Required when `content_config` is `CONTENT_CONFIG_STRUCTURED_DATA`."
  type        = string
  default     = null
}

# The display name of the datastore.
variable "datastore_display_name" {
  description = "The display name of the datastore."
  type        = string
  default     = null
}

# A unique identifier for the datastore.
variable "datastore_id" {
  description = "A unique identifier for the datastore. Must be alphanumeric and may contain hyphens, and be up to 63 characters long."
  type        = string
  default     = null
}

# The base display name for the Vertex AI App.
variable "display_name" {
  description = "The base display name for the Vertex AI Engine. A suffix of '-engine' will be added automatically. Required when solution_type is 'SOLUTION_TYPE_CHAT'."
  type        = string
  default     = null
}

# A unique identifier for the engine.
variable "engine_id" {
  description = "A unique identifier for the engine (App). Required when solution_type is 'SOLUTION_TYPE_CHAT'. Must be alphanumeric and may contain hyphens, and be up to 63 characters long."
  type        = string
  default     = null
}

# The industry vertical that the datastore registers.
variable "industry_vertical" {
  description = "The industry vertical that the datastore registers. For example, `GENERIC`, `MEDIA`, `HEALTHCARE`."
  type        = string
  default     = "GENERIC"
}

# The location for the Vertex AI Search and Conversation resources.
variable "location" {
  description = "The location for the Vertex AI Search and Conversation resources. Can be `global`, `us`, or `eu`."
  type        = string
  default     = "global"
}

# The project ID to deploy the resources in.
variable "project_id" {
  description = "The ID of the project in which to create the Vertex AI Search and Conversation resources. If not provided, the provider project is used."
  type        = string
  default     = null
}

# Configuration for a search app.
variable "search_engine_config" {
  description = "DEPRECATED: Configuration for a search app. This is no longer supported by the underlying provider. Please set to null."
  type = object({
    search_tier    = optional(string, "SEARCH_TIER_STANDARD")
    search_add_ons = optional(list(string), [])
  })
  default  = null
  nullable = true
}

# The solution type for the app.
variable "solution_type" {
  description = "The solution type for the app. Valid values are `SOLUTION_TYPE_SEARCH` or `SOLUTION_TYPE_CHAT`."
  type        = string
  default     = null

  validation {
    condition     = var.solution_type == null ? true : contains(["SOLUTION_TYPE_SEARCH", "SOLUTION_TYPE_CHAT"], var.solution_type)
    error_message = "Allowed values for solution_type are SOLUTION_TYPE_SEARCH or SOLUTION_TYPE_CHAT."
  }
}
