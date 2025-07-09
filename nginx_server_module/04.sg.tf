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