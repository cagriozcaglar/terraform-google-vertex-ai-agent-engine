variable "project_id" {
  description = "The ID of the Google Cloud project in which to provision the resources."
  type        = string
  default     = null
}

variable "location" {
  description = "The location for the Dialogflow CX Agent. This is the primary region for the agent and its associated tools."
  type        = string
  default     = null
}

variable "display_name" {
  description = "The human-readable display name for the Dialogflow CX Agent."
  type        = string
  default     = null
}

variable "time_zone" {
  description = "The time zone of the agent from the IANA Time Zone Database. For example, America/New_York, Europe/Paris."
  type        = string
  default     = null
}

variable "default_language_code" {
  description = "The default language of the agent as a language tag (e.g., 'en', 'en-US')."
  type        = string
  default     = "en"
}

variable "description" {
  description = "The description of the agent. The maximum length is 500 characters."
  type        = string
  default     = null
}

variable "avatar_uri" {
  description = "The URI of the agent's avatar. Avatars are used throughout the Dialogflow console and in the self-hosted Web Demo integration."
  type        = string
  default     = null
}

variable "enable_stackdriver_logging" {
  description = "Determines whether Stackdriver logging is enabled for the agent."
  type        = bool
  default     = true
}

variable "enable_spell_correction" {
  description = "Indicates if automatic spell correction is enabled for this agent."
  type        = bool
  default     = false
}

variable "advanced_settings" {
  description = "Hierarchical advanced settings for this agent. The structure of this object must follow the schema for the 'advancedSettings' argument in the google_dialogflow_cx_agent resource. For example, to configure audio export: `{ audio_export_gcs_destination = { uri = 'gs://your-bucket/audio/' } }`"
  type        = any
  default     = null
}

variable "gen_app_builder_settings" {
  description = "Settings for Generative App Builder. If this is not set, generative features will be disabled. To enable, set to an object like `{ engine = 'projects/your-project-id/locations/global/collections/default_collection/dataStores/your-datastore-id' }`."
  type        = any
  default     = null
}

variable "text_to_speech_settings" {
  description = "Settings for text-to-speech. This object must conform to the 'textToSpeechSettings' argument schema in the google_dialogflow_cx_agent resource. For example: `{ synthesize_speech_configs = jsonencode({'en-US': {'voice': {'name': 'en-US-Wavenet-D'}}}) }`."
  type        = any
  default     = null
}

variable "speech_to_text_settings" {
  description = "Settings for speech-to-text. This object must conform to the 'speechToTextSettings' argument schema in the google_dialogflow_cx_agent resource. For example: `{ enable_speech_adaptation = true }`."
  type        = any
  default     = null
}

variable "tools" {
  description = "A map of tool configurations to create for the agent. The key of the map is a logical name used for referencing the tool."
  type = map(object({
    display_name        = string
    description         = optional(string)
    openapi_spec_schema = string
  }))
  default  = {}
  nullable = false
}

variable "datastore_config" {
  description = "Configuration for a Discovery Engine Datastore to be created as a knowledge base for the agent. If null, no datastore is created."
  type = object({
    data_store_id     = string
    display_name      = string
    industry_vertical = string
    solution_types    = list(string)
    content_config    = string
  })
  default = null
}

variable "datastore_location" {
  description = "The location for the Discovery Engine Datastore. Can be 'global' or a multi-regional location like 'us' or 'eu'."
  type        = string
  default     = "global"
}
