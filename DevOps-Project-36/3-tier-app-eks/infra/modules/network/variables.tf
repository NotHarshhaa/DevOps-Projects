variable "aws_azs" {
  description = "AWS region"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "List of private subnets"
  type        = list(string)

}
variable "public_subnets_cidr" {
  description = "List of private subnets"
  type        = list(string)

}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}