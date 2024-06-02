output "instance_id" {
  value = aws_instance.win22_instance.id
}

output "instance_tags" {
  value = aws_instance.win22_instance.tags_all
}
