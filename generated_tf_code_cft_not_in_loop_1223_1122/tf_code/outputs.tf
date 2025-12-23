output "app_name" {
  description = "The full resource name of the created Vertex AI Search App."
  value       = google_vertex_ai_search_app.main.name
}

output "created_data_stores" {
  description = "A map of the data stores created by this module, with their full resource names and IDs."
  value = {
    for k, v in google_vertex_ai_search_data_store.main : k => {
      name          = v.name
      data_store_id = v.data_store_id
    }
  }
}

output "engine_id" {
  description = "The unique ID of the Engine."
  value       = google_vertex_ai_search_app.main.engine_config[0].engine_id
}

output "service_agent" {
  description = "The service account email for the Vertex AI Search service agent."
  value       = google_project_service_identity.discovery_engine_sa.email
}
