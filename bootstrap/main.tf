provider "aws" {
  region = "eu-central-1"
}


resource "aws_s3_bucket" "backend_s3" {

    bucket = "qr-gen-terraform-state"
    
  
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend_s3.id
  versioning_configuration {
    status = "Enabled"
  }

}