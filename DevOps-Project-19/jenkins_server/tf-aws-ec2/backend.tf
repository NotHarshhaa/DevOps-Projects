terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-7001"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}