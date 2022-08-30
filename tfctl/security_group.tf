resource "aws_security_group" "sg_web" {
  name        = "${var.name}-sgtoec2-web-01"
  description = "allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "outbound_any-any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound_s:any-t:22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "inbound_s:any-t:80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.common_tags,
    {
      Name      = "${var.name}-sgtoec2-web-01"
      Timestamp = timestamp()

    }
  )
}