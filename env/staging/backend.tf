terraform {
  backend "s3" {
    bucket  = "demo-aws-terraform-state-583e7c1d"
    key     = "aws-demo/staging/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}