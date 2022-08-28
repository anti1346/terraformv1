### S3 bucket for backend
resource "aws_s3_bucket" "terraform_state" {
  bucket = "okahpt16-terraform-s3-bucket"
}

resource "aws_s3_bucket_acl" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "terraform_state_version" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "okahpt16_terraform_lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

}