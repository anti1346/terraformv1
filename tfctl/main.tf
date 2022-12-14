locals {
  common_tags = {
    Name        = "${var.project_name}-${var.environment}"
    Project     = var.project_name
    Owner       = var.owner
    Environment = var.environment
    Terraform   = "true"
    Description = "Managed by Terraform"
  }
}


################################################################################
################################################################################
################################################################################
##### VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name             = var.name
  cidr             = var.cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = false
  enable_vpn_gateway   = false

}

##### 키 페어
################################################################################
################################################################################
################################################################################
resource "aws_key_pair" "my_sshkey" {
  key_name   = "my_sshkey"
  public_key = file("~/aws-key-pair/iac-test.pub")
}

##### EC2 인스턴스
################################################################################
################################################################################
################################################################################
/* resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  # subnet_id = module.${var.vpc_name}.public_subnets[0].id
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
  */

/* module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"
} */

resource "aws_instance" "ec2instance_web" {
  count = 1
  /* count = length(var.public_subnets) */
  /* count                  = var.instance_per_subnet * length(module.my_vpc.public_subnets) */
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  /* subnet_id              = module.vpc.public_subnets[count.index] */
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  key_name               = aws_key_pair.my_sshkey.key_name
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  user_data              = file("provisioning-scripts/web_deploy_redhat.sh")

  lifecycle {
    ignore_changes = [
      tags["timestamp"],
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name        = "web-server-${count.index + 1}"
      Description = "description definition"
      ServerRole  = "web"
      timestamp   = timestamp()

    }
  )
}

##### EC2 탄력적 IP
resource "aws_eip" "my_eip" {
  count = 1
  /* count    = length(var.public_subnets) */
  vpc      = true
  instance = aws_instance.ec2instance_web[count.index].id

  lifecycle {
    ignore_changes = [
      tags["Timestamp"],
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name        = "web-server-${count.index + 1}"
      Description = "description definition"
      Timestamp   = timestamp()
    }
  )
}

################################################################################
################################################################################
################################################################################