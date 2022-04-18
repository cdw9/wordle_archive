provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::137242125837:role/OrganizationAccountAccessRole"
  }
}

# Storing the state file in an encrypted s3 bucket
terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "sfu-terraform-state"
    key            = "caleb.wordle_archive.json"
    encrypt        = true
    dynamodb_table = "sfu-terraform-state"
  }
}

# additional providers
provider "aws" {
  alias  = "utility"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::339610064134:role/OrganizationAccountAccessRole"
  }
}
