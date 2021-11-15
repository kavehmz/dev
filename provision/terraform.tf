terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      env = "dev"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-tfstate-dev.io"
    key    = "terraform-dev.tfstate"
    region = "us-east-1"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
