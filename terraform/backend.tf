provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

terraform {
  backend "s3" {
    region  = "us-east-2"
    bucket  = "tfstate-k4fm3-20200522"
    key     = "caleb.wordle_archive.json"
    encrypt = true
  }
}
