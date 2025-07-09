########## Instancia ###########
resource "aws_instance" "ec2-nginx-server" {
  ami = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  key_name = aws_key_pair.lab-kp-nginx-server.key_name

  vpc_security_group_ids = [
    aws_security_group.lab-sg-nginx-server.id
  ]

  tags = {
    Name        = var.server_name
    Environment = var.environment
    Owner       = "info@hugobali.com"
    Team        = "DevOps"
    Project     = "LabAWS"
  }
}