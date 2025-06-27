terraform {
  backend "s3" {
    bucket = "project1-s3-bucket-stateform" # CHANGE THIS to a unique S3 bucket name
    key    = "project1-custom-k8s/terraform.tfstate"
    region = "us-east-1"
  }
}