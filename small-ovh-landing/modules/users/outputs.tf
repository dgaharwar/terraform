output "user" {
  value       = ovh_cloud_project_user.iac_user
  description = "Detailed information of user dedicated to manage resources."
  sensitive   = true
}
