terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_instance" "app_server" {
 ami           = "ami-01b6d88af12965bb6"
  instance_type = "t3.micro"
  subnet_id = "<subnet-id>"

  tags = {
    Name = "Terraform_Demo"
  }
}

