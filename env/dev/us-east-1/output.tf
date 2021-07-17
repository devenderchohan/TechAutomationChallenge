output "instance_public_ip" {
  value = aws_instance.instance.public_ip
}
output "instance_public_dns" {
  value = aws_instance.instance.public_dns
}
output "rds_endpoint" {
  value = aws_db_instance.data.endpoint
}

output "rds_user" {
  value = aws_db_instance.data.username
}

output "rds_password" {
  sensitive = true
  value = aws_db_instance.data.password
}