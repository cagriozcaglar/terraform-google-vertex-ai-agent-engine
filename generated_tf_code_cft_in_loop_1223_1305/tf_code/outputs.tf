# The full resource name of the created Datastore.
output "data_store_name" {
  description = "The full resource name of the created Datastore."
  value       = length(google_discovery_engine_data_store.main) > 0 ? google_discovery_engine_data_store.main[0].name : null
}

# The unique ID of the created datastore.
output "datastore_id" {
  description = "The unique ID of the created datastore."
  value       = length(google_discovery_engine_data_store.main) > 0 ? google_discovery_engine_data_store.main[0].data_store_id : null
}

# The unique ID of the created Engine.
output "engine_id" {
  description = "The unique ID of the created Engine. This is only applicable for SOLUTION_TYPE_CHAT."
  value       = length(google_discovery_engine_chat_engine.main) > 0 ? google_discovery_engine_chat_engine.main[0].engine_id : "N/A for SOLUTION_TYPE_SEARCH"
}

# The full resource name of the created Engine.
output "engine_name" {
  description = "The full resource name of the created Engine. This is only applicable for SOLUTION_TYPE_CHAT."
  value       = length(google_discovery_engine_chat_engine.main) > 0 ? google_discovery_engine_chat_engine.main[0].name : "N/A for SOLUTION_TYPE_SEARCH"
}
