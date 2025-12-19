# The variables.tf file is used to declare input variables for the Terraform module.
# These variables allow users to customize the resources created by the module.

# The Google Cloud project ID where the agent will be created.
variable "project_id" {
  description = "The Google Cloud project ID where the agent will be created. If not provided, the provider's project is used."
  type        = string
  default     = null
}

# The Google Cloud location for the agent.
variable "location" {
  description = "The Google Cloud location for the agent. This can be a region, e.g., `us-central1`."
  type        = string
  default     = "global"
}

# The human-readable name of the agent, unique within its location.
variable "display_name" {
  description = "The human-readable name of the agent, unique within its location."
  type        = string
  default     = "tf-generated-dialogflow-cx-agent"
}

# The default language of the agent as a BCP-47 language tag.
variable "default_language_code" {
  description = "The default language of the agent as a BCP-47 language tag. Example: 'en'."
  type        = string
  default     = "en"
}

# The time zone of the agent from the IANA time zone database.
variable "time_zone" {
  description = "The time zone of the agent from the IANA time zone database. Example: 'America/New_York'."
  type        = string
  default     = "America/New_York"
}

# A description for the agent.
variable "description" {
  description = "A description for the agent."
  type        = string
  default     = null
}

# The URI of the agent's avatar.
variable "avatar_uri" {
  description = "The URI of the agent's avatar."
  type        = string
  default     = null
}

# A list of BCP-47 language tags for languages supported by the agent.
variable "supported_language_codes" {
  description = "A list of BCP-47 language tags for languages supported by the agent, in addition to the default language."
  type        = list(string)
  default     = null
}

# The full resource name of the Vertex AI Search data store to connect to.
variable "gen_app_builder_engine" {
  description = "The full resource name of the Vertex AI Search data store to connect to for generative AI capabilities. Format: `projects/{project}/locations/{location}/collections/{collection}/dataStores/{data_store}`."
  type        = string
  default     = null
}

# Settings for speech-to-text.
variable "speech_to_text_settings" {
  description = "An object with settings for speech-to-text. Set to enable speech adaptation, which is useful for voice bots."
  type = object({
    enable_speech_adaptation = bool
  })
  default = null
}

# Advanced logging settings for the agent.
variable "advanced_logging_settings" {
  description = "An object with advanced logging settings for the agent. If not provided, default logging settings are used."
  type = object({
    enable_interaction_logging = bool
    enable_stackdriver_logging = bool
  })
  default = null
}

# The full resource name of the Security Settings to apply to the agent.
variable "security_settings" {
  description = "The full resource name of the Security Settings to apply to the agent. Format: `projects/{project}/locations/{location}/securitySettings/{security_setting}`."
  type        = string
  default     = null
}

# Spell correction setting for the agent.
variable "enable_spell_correction" {
  description = "If true, automatic spell correction is enabled for user inputs."
  type        = bool
  default     = false
}
