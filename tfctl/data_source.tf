data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ubuntu-0.1_2208300905"]
  }
}