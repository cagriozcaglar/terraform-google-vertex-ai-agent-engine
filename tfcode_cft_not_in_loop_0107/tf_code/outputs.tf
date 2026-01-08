output "agent_id" {
  description = "The unique identifier of the created Dialogflow CX Agent."
  value       = local.create_agent ? google_dialogflow_cx_agent.main[0].id : null
}

output "agent_name" {
  description = "The full resource name of the created Dialogflow CX Agent."
  value       = local.create_agent ? google_dialogflow_cx_agent.main[0].name : null
}

output "agent_start_flow" {
  description = "The name of the start flow of the created agent."
  value       = local.create_agent ? google_dialogflow_cx_agent.main[0].start_flow : null
}

output "tools" {
  description = "A map of the created tools, where the key is the logical name and the value is the tool's full resource name."
  value = {
    for k, v in google_dialogflow_cx_tool.main : k => v.name
  }
}

output "datastore_id" {
  description = "The unique identifier of the created Discovery Engine Datastore. This will be null if no datastore was created."
  value       = local.create_datastore ? google_discovery_engine_data_store.main[0].id : null
}

output "datastore_name" {
  description = "The full resource name of the created Discovery Engine Datastore. This will be null if no datastore was created."
  value       = local.create_datastore ? google_discovery_engine_data_store.main[0].name : null
}

output "datastore_service_identity" {
  description = "The email of the service account created for the Discovery Engine Datastore. This will be null if no datastore was created."
  value       = local.create_datastore ? google_project_service_identity.gcp_sa_vert_search[0].email : null
}
