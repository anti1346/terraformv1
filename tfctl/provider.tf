terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
    }

  }

  backend "s3" {
    bucket         = "okahpt16-terraform-s3-bucket"
    key            = "terraform/kr/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "okahpt16_terraform_lock"
    profile        = "terraform"

  }

}

provider "aws" {
  # Configuration options
  profile = "terraform"
  region  = "ap-northeast-2"
  /* shared_credentials_file = "~/.aws/credentials" */
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}
