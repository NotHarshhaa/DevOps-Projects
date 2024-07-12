terraform {
    backend "s3" {
        bucket = "s3statefile786"
        key = "state-lock"
        region = "us-east-1"
        aws_dynamodb_table = "state-lock"
    }
}
