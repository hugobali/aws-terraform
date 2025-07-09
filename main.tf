provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2-nginx-server" {
  ami = "ami-05ffe3c48a9991133"
  instance_type = "t3.micro"

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
    Name        = "nginx-server"
    Environment = "lab"
    Owner       = "info@hugobali.com"
    Team        = "DevOps"
    Project     = "LabAWS"
  }


}
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
resource "aws_key_pair" "lab-kp-nginx-server" {
  key_name = "lab-kp-nginx-server"
  public_key = file("nginx-server.key.pub")

  tags = {
    Name        = "lab-kp-nginx-server"
    Environment = "lab"
    Owner       = "info@hugobali.com"
    Team        = "DevOps"
    Project     = "LabAWS"
  }
}

resource "aws_security_group" "lab-sg-nginx-server" {
  name        = "lab-sg-nginx-server"
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
    Name        = "lab-sg-nginx-server"
    Environment = "lab"
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