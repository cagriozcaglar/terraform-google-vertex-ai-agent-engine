variable "agent_display_name" {
  description = "The human-readable display name for the Vertex AI Search Chat Engine."
  type        = string
  default     = "My Vertex AI Chat Engine"
}

variable "chat_engine_id" {
  description = "A unique identifier for the Chat Engine. Must be alphanumeric and up to 40 characters long. If not provided, a random one will be generated."
  type        = string
  default     = null
}

variable "company_name" {
  description = "The name of the company to use in agent responses."
  type        = string
  default     = null
}

variable "data_store_content_config" {
  description = "The content configuration for the data store. Specifies how data is provided to the data store. Allowed values: 'NO_CONTENT', 'CONTENT_REQUIRED', 'PUBLIC_WEBSITE'."
  type        = string
  default     = "CONTENT_REQUIRED"
}

variable "data_store_display_name" {
  description = "The human-readable display name for the data store that grounds the agent."
  type        = string
  default     = "My Vertex AI Chat Data Store"
}

variable "data_store_id" {
  description = "A unique identifier for the data store. Must be alphanumeric and up to 60 characters long. If not provided, a random one will be generated."
  type        = string
  default     = null
}

variable "default_language_code" {
  description = "The default language code for the agent, e.g., 'en'."
  type        = string
  default     = "en"
}

variable "location" {
  description = "The GCP location for the app and data store. Must be one of 'global', 'us', 'eu'."
  type        = string
  default     = "global"
}

variable "project_id" {
  description = "The ID of the project in which the resources will be created. If not provided, the provider project will be used."
  type        = string
  default     = null
}

variable "time_zone" {
  description = "The time zone of the agent, e.g., 'America/Los_Angeles'."
  type        = string
  default     = "America/Los_Angeles"
}
