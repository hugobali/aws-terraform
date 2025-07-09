####### tfstate #######
terraform {
  backend "s3" {
    bucket         = "hugobali-terraform"
    key            = "lab-terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}

###### modules ########
module "nginx_server_dev" {
  source = "./nginx_server_module"

  ami_id = "ami-0440d3b780d96b29d"
  instance_type = "t3.micro"
  server_name = "nginx-server-dev"
  environment = "dev"
}

module "nginx_server_qa" {
  source = "./nginx_server_module"

  ami_id = "ami-0440d3b780d96b29d"
  instance_type = "t3.medium"
  server_name = "nginx-server-qa"
  environment = "qa"
}


########  output ####### 
output "nginx_dev_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_dev.server_public_dns
}



output "nginx_qa_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_qa.server_public_dns
}

resource "aws_instance" "server-web" {
  ami                                  = "ami-05ffe3c48a9991133"
  instance_type                        = "t3.micro"
  tags                                 = {
      "Name" = "server-web"
      Environment = "Import"
      Owner       = "info@hugobali.com"
      Team        = "DevOps"
      Project     = "TF Import"
    }
  
  vpc_security_group_ids               = [
        "sg-0030abc21a1a23fa5",
  ]
}


