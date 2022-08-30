packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  # timestamp = formatdate("YYMMDD-hhmm", timestamp())
  ami_name    = "wordpress"
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

source "amazon-ebs" "wordpress" {
  profile = "terraform"
  region  = "ap-northeast-2"

  #   ami_name      = "wordpress-${local.timestamp}"
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

  force_deregister = true

  tags = {
    Name        = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
    Project     = "project_name"
    Owner       = "owner_name"
    Environment = "environment_name"
    Managed     = "managedbyterraform"
  }

  run_tags = {
    Name        = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
    Project     = "project_name"
    Owner       = "owner_name"
    Environment = "environment_name"
    Managed     = "managedbyterraform"
  }
}

build {
  name = "wordpress-build"
  sources = [
    "source.amazon-ebs.wordpress"
  ]

  provisioner "ansible" {
    playbook_file = "./ansible/site.yaml"
    extra_arguments = [
      "--become",
    ]
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
    ]
  }
}