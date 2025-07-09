####### Variables #######

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  default     = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "server_name" {
  description = "Nombre del servidor web"
  default     = "nginx-server"
}

variable "environment" {
  description = "Ambiente de la aplicación"
  default     = "lab"
}



####### Provider ###########
provider "aws" {
  region = "us-east-1"
}

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
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
resource "aws_key_pair" "lab-kp-nginx-server" {
  key_name = "lab-kp-${var.server_name}"
  public_key = file("${var.server_name}.key.pub")

  tags = {
    Name        = "lab-kp-${var.server_name}"
    Environment = var.environment
    Owner       = "info@hugobali.com"
    Team        = "DevOps"
    Project     = "LabAWS"
  }
}

resource "aws_security_group" "lab-sg-nginx-server" {
  name        = "lab-sg-${var.server_name}"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "lab-sg-${var.server_name}"
    Environment = var.environment
    Owner       = "info@hugobali.com"
    Team        = "DevOps"
    Project     = "LabAWS"
  }

}


####### Output #######
output "server_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.ec2-nginx-server.public_ip
}

output "server_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.ec2-nginx-server.public_dns
}