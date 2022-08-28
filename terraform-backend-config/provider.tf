terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
    }

  }
}

provider "aws" {
  # Configuration options
  profile = "terraform"
  region  = "ap-northeast-2"

}