terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  # access_key = "${var.ACCESS_KEY}"
  # secret_key = "${var.SECRET_KEY}"
  # shared_credentials_file = "~/.aws/creds"
  region     = "${var.REGION}"
}