/**
output "new_db_instance_name" {
  description = "The name of the RDS instance"
  value       = aws_db_instance.new_db.name
}

output "new_db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.new_db.arn
}


output "new_db_instance_endpoint" {
  description = "The Endpoint of the RDS instance"
  value       = aws_db_instance.new_db.address
}

output "new_db_instance_username" {
  description = "The username of the new RDS"
  value       = aws_db_instance.new_db.username
}

output "new_db_instance_password" {
  description = "The password for the user"
  value       = aws_db_instance.new_db.password
}

output "new_secret_arn" {
  description = "The ARN for the new Secret in SOC"
  value = "${aws_secretsmanager_secret.new_secret_object.arn}"
}
*/
