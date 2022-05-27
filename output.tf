output "ansible_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.Ansible.id
}

output "ansible_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Ansible.public_ip
}

output "servidor_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.Servidor[*].id
}

output "servidor_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Servidor[*].public_ip
}
