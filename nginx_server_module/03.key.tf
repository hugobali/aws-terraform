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