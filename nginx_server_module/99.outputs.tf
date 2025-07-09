####### Output #######
output "server_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.ec2-nginx-server.public_ip
}

output "server_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.ec2-nginx-server.public_dns
}