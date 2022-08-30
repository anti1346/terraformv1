packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  #   timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  timestamp   = formatdate("YYMMDDhhmm", timestamp())
  ami_name    = "redis"
  ami_version = 0.1
  common_tags = {
    Name        = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
    Project     = "project_name"
    Owner       = "owner_name"
    Environment = "environment_name"
    Packer      = "true"
    Description = "Managed by Packer"
  }
}

source "amazon-ebs" "ubuntu" {
  profile = "terraform"
  region  = "ap-northeast-2"

  ami_name      = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  instance_type = "t3.small"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = merge(
    local.common_tags,
    {
      Description = "description definition"
    }
  )
  run_tags = merge(
    local.common_tags,
    {
      Description = "description definition"
    }
  )
}

build {
  name = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing Redis",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y redis-server",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
}
