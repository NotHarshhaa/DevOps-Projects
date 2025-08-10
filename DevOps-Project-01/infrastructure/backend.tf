terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  #   backend "s3" {
  #     bucket         = "my-jenkins-tf-state-bucket"
  #     key            = "jenkins-infra/terraform.tfstate"
  #     region         = "us-east-1"
  #     dynamodb_table = "jenkins-tf-lock-table"
  #     encrypt        = true
  #   }
}
