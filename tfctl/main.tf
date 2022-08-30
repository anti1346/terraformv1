locals {
  common_tags = {
    Name        = "${var.project_name}-${var.environment}"
    Project     = var.project_name
    Owner       = "owner_name"
    Environment = var.environment
    Terraform   = "true"
  }
}

### VPN 생성
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name            = var.name
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  /* lifecycle {
    ignore_changes = [
      tags["timestamp"]
    ]
  } */

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Createddate = timestamp()
  }
}

resource "aws_key_pair" "my_sshkey" {
  key_name   = "my_sshkey"
  public_key = file("~/aws-key-pair/iac-test.pub")
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]
  /* subnet_id = module.${var.vpc_name}.public_subnets[0].id */
  subnet_id = module.vpc.public_subnets[0]

  key_name = aws_key_pair.my_sshkey.key_name

  lifecycle {
    ignore_changes = [
      tags["timestamp"],
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Description = "description definition"
      timestamp   = timestamp()

    }
  )
}

resource "aws_eip" "my_eip" {
  vpc      = true
  instance = aws_instance.ubuntu.id

  lifecycle {
    ignore_changes = [
      tags["timestamp"],
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Description = "description definition"
      timestamp   = timestamp()
    }
  )
}