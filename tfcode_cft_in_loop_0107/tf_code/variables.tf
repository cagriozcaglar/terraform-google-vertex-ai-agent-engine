# The default language code to use for the CHAT solution's agent (e.g., 'en'). Required if solution_type is 'SOLUTION_TYPE_CHAT'.
variable "chat_app_language_code" {
  description = "The default language code to use for the CHAT solution's agent (e.g., 'en'). Required if solution_type is 'SOLUTION_TYPE_CHAT'."
  type        = string
  default     = null
}

# The timezone of the CHAT solution's agent (e.g., 'America/Los_Angeles'). Required for 'SOLUTION_TYPE_CHAT'.
variable "chat_app_time_zone" {
  description = "The timezone of the CHAT solution's agent (e.g., 'America/Los_Angeles'). Required for 'SOLUTION_TYPE_CHAT'."
  type        = string
  default     = "America/Los_Angeles"
}

# The display name for the business in the CHAT solution's agent. This is used in agent responses.
variable "chat_app_business" {
  description = "The display name for the business in the CHAT solution's agent. This is used in agent responses."
  type        = string
  default     = ""
}

# The collection ID. For now, only 'default_collection' is supported.
variable "collection_id" {
  description = "The collection ID. For now, only 'default_collection' is supported."
  type        = string
  default     = "default_collection"
}

# A map of data stores to create and connect to the engine. The key is the 'data_store_id'. Each value is an object with a 'display_name' and an optional 'content_config' (defaults to 'NO_SCHEMA'). Note Data must be imported into the data store after creation.
variable "data_stores" {
  description = "A map of data stores to create and connect to the engine. The key is the 'data_store_id'. Each value is an object with a 'display_name' and an optional 'content_config' (defaults to 'NO_SCHEMA'). Note Data must be imported into the data store after creation."
  type = map(object({
    display_name   = string
    content_config = optional(string, "NO_SCHEMA")
  }))
  default = {
    "default-data-store" = {
      display_name   = "Default Data Store"
      content_config = "NO_SCHEMA"
    }
  }
}

# The base display name for the Discovery Engine App.
variable "display_name" {
  description = "The base display name for the Discovery Engine App."
  type        = string
  default     = "discovery-engine-app"
}

# A boolean to control the automatic enabling of the 'discoveryengine.googleapis.com' API.
variable "enable_apis" {
  description = "A boolean to control the automatic enabling of the 'discoveryengine.googleapis.com' API."
  type        = bool
  default     = true
}

# The industry vertical for the data stores.
variable "industry_vertical" {
  description = "The industry vertical for the data stores."
  type        = string
  default     = "GENERIC"
}

# The location for the Discovery Engine App and Data Stores. Can be global, multi-regional (e.g., 'eu', 'us'), or regional. Note - Data Stores for an app must be in the same location.
variable "location" {
  description = "The location for the Discovery Engine App and Data Stores. Can be global, multi-regional (e.g., 'eu', 'us'), or regional. Note - Data Stores for an app must be in the same location."
  type        = string
}

# The project ID to deploy the Discovery Engine resources in.
variable "project_id" {
  description = "The project ID to deploy the Discovery Engine resources in."
  type        = string
}

# A list of search add-ons for a SEARCH solution. e.g., ['SEARCH_ADD_ON_LLM']
variable "search_add_ons" {
  description = "A list of search add-ons for a SEARCH solution. e.g., ['SEARCH_ADD_ON_LLM']"
  type        = list(string)
  default     = []
}

# The search tier for a SEARCH solution. Can be 'SEARCH_TIER_STANDARD' or 'SEARCH_TIER_ENTERPRISE'.
variable "search_tier" {
  description = "The search tier for a SEARCH solution. Can be 'SEARCH_TIER_STANDARD' or 'SEARCH_TIER_ENTERPRISE'."
  type        = string
  default     = "SEARCH_TIER_STANDARD"
}

# The solution type for the engine. Can be 'SOLUTION_TYPE_SEARCH' or 'SOLUTION_TYPE_CHAT'.
variable "solution_type" {
  description = "The solution type for the engine. Can be 'SOLUTION_TYPE_SEARCH' or 'SOLUTION_TYPE_CHAT'."
  type        = string
  default     = "SOLUTION_TYPE_SEARCH"

  validation {
    condition     = contains(["SOLUTION_TYPE_SEARCH", "SOLUTION_TYPE_CHAT"], var.solution_type)
    error_message = "The solution_type must be either 'SOLUTION_TYPE_SEARCH' or 'SOLUTION_TYPE_CHAT'."
  }
}
