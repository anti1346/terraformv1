/* resource "aws_instance" "my_instance" {
  ami           = "ami-0ea5eb4b05645aa8a"
  instance_type = "t3.micro"

  tags = {
    Name = "MyInstance"
  }
} */

/* 
resource "aws_instance" "my_instance_b" {
  ami           = "ami-0ea5eb4b05645aa8a"
  instance_type = "t3.micro"
  depends_on = [
    aws_s3_bucket.my_bucket
  ]

  tags = {
    Name = "MyInstanceB"
  }
}

resource "aws_eip" "my_eip" {
  vpc      = true
  instance = aws_instance.my_instance_a.id
  tags = {
    "Name" = "MyInstanceA"
  }
}

resource "aws_s3_bucket" "my_bucket" {
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
} */