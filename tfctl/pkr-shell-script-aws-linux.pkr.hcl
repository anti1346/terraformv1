packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

################################################################################
################################################################################
################################################################################
variables {
  aws_region       = "ap-northeast-2"
  aws_profile      = "terraform"
  instance_type    = "t3.small"
  project_name     = "project_name"
  owner_name       = "owner_name"
  environment_name = "environment_name"
  description      = "Managed by Packer"
  ami_name         = "amazon2" #ubuntu|amazon2
  sources          = "amazon2" #ubuntu|amazon2

}

################################################################################
################################################################################
################################################################################
locals {
  #   timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  timestamp   = formatdate("YYMMDDhhmm", timestamp())
  ami_name    = var.ami_name
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

################################################################################
################################################################################
################################################################################
#### ubuntu(official accounts : 099720109477)
source "amazon-ebs" "ubuntu" {
  profile                     = var.aws_profile
  region                      = var.aws_region
  ami_name                    = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  instance_type               = var.instance_type
  ssh_username                = ubuntu
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

  snapshot_tags = merge(
    local.common_tags,
    {
      Description = var.description
    }
  )

}

##### amazon(official accounts : 137112412989)
source "amazon-ebs" "amazon2" {
  profile                     = var.aws_profile
  region                      = var.aws_region
  ami_name                    = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  instance_type               = var.instance_type
  ssh_username                = "ec2-user"
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-*-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
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

  snapshot_tags = merge(
    local.common_tags,
    {
      Description = var.description
    }
  )

}

##### centos(official accounts : 125523088429)

################################################################################
################################################################################
################################################################################
build {
  name = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  sources = [
    "source.amazon-ebs.${var.sources}"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    script       = "provisioning-scripts/z.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

  provisioner "shell" {
    inline = [
      "sleep 30",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }
}
