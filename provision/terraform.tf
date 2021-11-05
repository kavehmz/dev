terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-tfstate-dev.io"
    key    = "home"
    region = "us-east-1"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
