packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variables {
  aws_region       = "ap-northeast-2"
  aws_profile      = "terraform"
  instance_type    = "t3.small"
  project_name     = "project_name"
  owner_name       = "owner_name"
  environment_name = "environment_name"
  description      = "Managed by Packer"
  ssh_username     = "ubuntu"

}

locals {
  #   timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  timestamp   = formatdate("YYMMDDhhmm", timestamp())
  ami_name    = "ubuntu"
  ami_version = 0.1
  common_tags = {
    Name        = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
    Project     = var.project_name
    Owner       = var.owner_name
    Environment = var.environment_name
    Packer      = true
    Description = var.description
  }
}

source "amazon-ebs" "ubuntu" {
  profile                     = var.aws_profile
  region                      = var.aws_region
  ami_name                    = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  instance_type               = var.instance_type
  ssh_username                = var.ssh_username
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  tags = merge(
    local.common_tags,
    {
      Description = var.description
    }
  )

  run_tags = merge(
    local.common_tags,
    {
      Description = var.description
    }
  )
}

build {
  name = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  # # Execute setup script
  # provisioner "shell" {
  #   script = "setup.sh"
  #   # Run script after cloud-init finishes, otherwise you run into race conditions
  #   execute_command = "/usr/bin/cloud-init status --wait && sudo -E -S sh '{{ .Path }}'"
  # }

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    script       = "provisioning-scripts/z.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

  provisioner "shell" {
    inline = ["echo 'This provisioner runs last'"]
  }
}
