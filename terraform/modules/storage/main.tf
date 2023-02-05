
# blogs:
# https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
# https://www.linkedin.com/pulse/terraform-state-remote-storage-s3-locking-dynamodb-oramu-/?trk=pulse-article_more-articles_related-content-card


# s3 bucket for terraform state
resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "bobsshop-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}


# this will add versioning to the bucket so that on every update to the bucket creates a new version
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tf_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# DynamoDB for locking the state file
resource "aws_dynamodb_table" "state_lock" {
  hash_key     = "LockID"
  name         = "bobsshop-terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
