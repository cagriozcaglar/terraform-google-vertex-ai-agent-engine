# The main.tf file contains the core resource definitions for the Terraform module.
# This resource creates a Vertex AI Agent Engine, which is a Dialogflow CX Agent.
# The agent is the top-level container for all conversational flows, intents, and entities.
resource "google_dialogflow_cx_agent" "main" {
  # The ID of the project in which the resource belongs.
  project = var.project_id
  # The human-readable name of the agent, unique within the location.
  display_name = var.display_name
  # The location of the agent. Examples: `global`, `us-central1`.
  location = var.location
  # The default language of the agent as a language tag. See [Language Support](https://cloud.google.com/dialogflow/cx/docs/reference/language) for a list of the currently supported language codes.
  default_language_code = var.default_language_code
  # The time zone of the agent from the [time zone database](https://www.iana.org/time-zones), e.g., America/New_York, Europe/Paris.
  time_zone = var.time_zone
  # The description of the agent.
  description = var.description
  # The URI of the agent's avatar. Avatars are not copied when training a new version of the agent.
  avatar_uri = var.avatar_uri
  # The list of all languages supported by this agent (besides default_language_code).
  supported_language_codes = var.supported_language_codes
  # Name of the SecuritySettings reference for the agent. Format: `projects/<Project ID>/locations/<Location ID>/securitySettings/<Security Settings ID>`.
  security_settings = var.security_settings
  # Indicates if automatic spell correction is enabled in detect intent requests.
  enable_spell_correction = var.enable_spell_correction

  # Dynamically configure the Generative AI settings if a Vertex AI Search data store is provided.
  # This enables Retrieval-Augmented Generation (RAG) capabilities.
  dynamic "gen_app_builder_settings" {
    # This block is created only if var.gen_app_builder_engine is not null.
    for_each = var.gen_app_builder_engine != null ? [var.gen_app_builder_engine] : []
    content {
      # The full resource name of the engine to connect to.
      engine = gen_app_builder_settings.value
    }
  }

  # Dynamically configure speech-to-text settings.
  # This is typically used for voice-based agents (e.g., IVR systems).
  dynamic "speech_to_text_settings" {
    # This block is created only if var.speech_to_text_settings is not null.
    for_each = var.speech_to_text_settings != null ? [var.speech_to_text_settings] : []
    content {
      # Whether to use speech adaptation for speech recognition.
      enable_speech_adaptation = speech_to_text_settings.value.enable_speech_adaptation
    }
  }

  # Dynamically configure advanced settings, such as logging.
  dynamic "advanced_settings" {
    # This block is created only if var.advanced_logging_settings is not null.
    for_each = var.advanced_logging_settings != null ? [var.advanced_logging_settings] : []
    content {
      # Settings for logging.
      logging_settings {
        # If true, DF CX interaction logging is enabled.
        enable_interaction_logging = advanced_settings.value.enable_interaction_logging
        # If true, Stackdriver logging is enabled.
        enable_stackdriver_logging = advanced_settings.value.enable_stackdriver_logging
      }
    }
  }
}
