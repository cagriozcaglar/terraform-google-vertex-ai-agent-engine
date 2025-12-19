# The outputs.tf file is used to declare outputs from the Terraform module.
# These outputs can be used to access information about the created resources.

# The full name of the created Vertex AI Agent.
output "name" {
  description = "The unique resource name of the agent. Format: projects/<Project ID>/locations/<Location ID>/agents/<Agent ID>."
  value       = google_dialogflow_cx_agent.main.name
}

# The display name of the agent.
output "display_name" {
  description = "The display name of the created agent."
  value       = google_dialogflow_cx_agent.main.display_name
}

# The name of the start flow, which is automatically created with the agent.
output "start_flow" {
  description = "The name of the start flow. This is the flow that is used when the session is created. Format: projects/<Project ID>/locations/<Location ID>/agents/<Agent ID>/flows/<Flow ID>."
  value       = google_dialogflow_cx_agent.main.start_flow
}
