locals {
  bucketName    = "techautomationchallenge-s3-terraform-remote-state"
  lockTableName = "techautomationchallenge-dynamodb-terraform-remote-state-lock"
}

#create a s3 resource for the provided aws region to store the state file.
resource "aws_s3_bucket" "terraform_tfstate_bucket" {
  #name needs to be globally unique
  bucket = local.bucketName
  #to prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
  #enable versioning
  versioning {
    enabled = true
  }
  #Enable server side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = local.bucketName
  }

}
resource "aws_s3_bucket_public_access_block" "source" {
  bucket                  = aws_s3_bucket.terraform_tfstate_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_statefile_lock" {
  hash_key     = "LockID"
  name         = local.lockTableName
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = local.lockTableName
  }
}
