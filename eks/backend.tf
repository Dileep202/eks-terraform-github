terraform {
  required_version = "~> 1.8.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }


backend "s3" {
  bucket = "myeksjourney"
  key    = "terraform.tfstate"
  region = "ap-south-1"
  dynamodb_table = "myeksjourney"
  encrypt = true
}
}
provider "aws" {
  region = var.region
}
