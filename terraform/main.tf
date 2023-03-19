
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



module "bobs_inventory_service_api" {
  source = "./modules/lambda"

  service_name              = "bobs_inventory_service"
  path_to_layer_zip         = "../inventory_service/package.zip"
  names                     = ["get_inventory_item"]
  paths_to_lambda_functions = ["../inventory_service/lambda_functions/get_inventory_item"]
  runtimes                  = ["python3.9"]
}
