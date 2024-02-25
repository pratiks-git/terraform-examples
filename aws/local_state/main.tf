terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }  
  }
}

  provider "aws" {
    region = "us-west-2"
  }

  resource "aws_instance" "app_server" {
    ami        	= "ami-830c94e3"
    instance_type = "t2.micro"

    tags = {
       Name = "Terraform_demo"
    }
  }

