provider "aws" {

    region = "eu-central-1"
}

terraform {
  backend "s3" {

    region = "eu-central-1"
    bucket = "qr-gen-terraform-state"
    key = "dev/terraform.tfstate"
    
  }
}

module "vpc" {

  source = "./modules/vpc"
  
}

module "sg" {

  source = "./modules/sg"

  vpc_id = module.vpc.vpc_id
  
}

module "ec2" {

  source = "./modules/ec2"

  sg_id = module.sg.sg_id

  key_name = module.key_pair.key_name

  subnet_id = module.vpc.subnet_id
  
}

module "key_pair" {

  source = "./modules/key_pair"
  
}
