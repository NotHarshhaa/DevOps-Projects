provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create an S3 bucket
resource "aws_s3_bucket" "mybucket" {
    bucket = "s3statefile786"  # Change to a unique bucket name

    # Optional: Adding tags to the bucket
    tags = {
        Name        = "s3statefile786"
        Environment = "Dev"
    }
}

# Manage versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "mybucket_versioning" {
    bucket = aws_s3_bucket.mybucket.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Manage server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "mybucket_encryption" {
    bucket = aws_s3_bucket.mybucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

#create Dynamodb for state-locking

resource "aws_dynamodb_table" "state-lock" {
    name = "state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LOCKID"

    attribute {
        name = "LOCKID"
        type = "S"
    }
}