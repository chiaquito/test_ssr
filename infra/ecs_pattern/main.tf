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
  region = "ap-northeast-1"
}



# ssh authentication for ec2 bastion host
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
data "aws_key_pair" "key_pair" {
  key_name = var.aws_key_pair_key_name
  # key_pair_id        = "key-08be3c43633fe2d6f"
  include_public_key = true
}