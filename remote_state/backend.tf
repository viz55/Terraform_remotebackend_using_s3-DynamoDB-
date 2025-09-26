terraform {
  backend "s3" {
    bucket         = "<account-id>-terraform-states"
    key            = "myapp/prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
