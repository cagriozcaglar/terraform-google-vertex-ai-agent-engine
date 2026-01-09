# A map of the created Data Store resource names, keyed by the logical name provided in the input variable.
output "data_store_names" {
  description = "A map of the created Data Store resource names, keyed by the logical name provided in the input variable."
  value = {
    for k, v in google_discovery_engine_data_store.this : k => v.name
  }
}

# A map of the created Discovery Engine Data Store resource objects, keyed by the logical name provided in the input variable.
output "data_stores" {
  description = "A map of the created Discovery Engine Data Store resource objects, keyed by the logical name provided in the input variable."
  value       = google_discovery_engine_data_store.this
}

# The full Discovery Engine App resource object.
output "engine" {
  description = "The full Discovery Engine App resource object."
  value       = google_discovery_engine_app.this
}

# The unique ID of the Discovery Engine App.
output "engine_id" {
  description = "The unique ID of the Discovery Engine App."
  value       = google_discovery_engine_app.this.engine_id
}

# The resource name of the created Discovery Engine App.
output "engine_name" {
  description = "The resource name of the created Discovery Engine App."
  value       = google_discovery_engine_app.this.name
}
