output "chat_engine_id" {
  description = "The unique identifier of the created Chat Engine."
  value       = google_discovery_engine_chat_engine.main.engine_id
}

output "chat_engine_name" {
  description = "The full resource name of the created Chat Engine, in the format projects/{project}/locations/{location}/collections/{collection_id}/engines/{engine_id}."
  value       = google_discovery_engine_chat_engine.main.name
}

output "data_store_id" {
  description = "The unique identifier of the created Discovery Engine Data Store."
  value       = google_discovery_engine_data_store.main.data_store_id
}

output "data_store_name" {
  description = "The full resource name of the created Discovery Engine Data Store, in the format projects/{project}/locations/{location}/collections/default_collection/dataStores/{data_store_id}."
  value       = google_discovery_engine_data_store.main.name
}
