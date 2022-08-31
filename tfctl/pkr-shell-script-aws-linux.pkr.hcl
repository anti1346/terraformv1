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
  aws_profile      = "terraform"
  aws_region       = "ap-northeast-2" #{ 서울:ap-northeast-2, 도쿄:ap-northeast-1, 싱가포르:ap-southeast-1, 버지니아:us-east-1, 오리건:us-west-2 }
  ami_name         = "ubuntu18" #amazon2 | ubuntu22 | ubuntu18
  source_name      = "ubuntu18" #amazon2 | ubuntu22 | ubuntu18
  ami_version      = "0.1"
  instance_type    = "t3.small"
  project_name     = "web project"
  owner_name       = "pkradmin"
  environment_name = "development" #development | testing | staging | production 
  description      = "Managed by Packer"

}

################################################################################
################################################################################
################################################################################
locals {
  #   timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  timestamp   = formatdate("YYMMDDhhmm", timestamp())
  ami_name    = var.ami_name
  ami_version = var.ami_version
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
      name                = "amzn2-ami-hvm-2.0.*-x86_64-*"
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

#### ubuntu(official accounts : 099720109477)
source "amazon-ebs" "ubuntu22" {
  profile                     = var.aws_profile
  region                      = var.aws_region
  ami_name                    = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  instance_type               = var.instance_type
  ssh_username                = "ubuntu"
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
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

#### ubuntu(official accounts : 099720109477)
source "amazon-ebs" "ubuntu18" {
  profile                     = var.aws_profile
  region                      = var.aws_region
  ami_name                    = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  instance_type               = var.instance_type
  ssh_username                = "ubuntu"
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
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

##### centos(official accounts : 125523088429)

################################################################################
################################################################################
################################################################################
build {
  name = "${local.ami_name}-${local.ami_version}_${local.timestamp}"
  sources = [
    "source.amazon-ebs.${var.source_name}"
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
