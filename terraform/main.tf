
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 4.0"
    }
  }


  backend "s3" {
    bucket         = "bobsshop-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "bobsshop-terraform-state-locking"
    encrypt        = true
  }

}

# Configure the AWS Provider
provider "aws" {
  alias   = "stockholm"
  region  = "eu-north-1"
  profile = "bob"
}



module "test_lambda" {
  source = "./modules/lambda"

  names       = ["test_lambda"]
  source_dirs = ["../src/"]
  runtimes    = ["python3.9"]

  # providers = {
  #   aws.nested_provider_alias = aws.stockholm
  # }
}
