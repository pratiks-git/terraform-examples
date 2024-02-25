terraform {
  backend "s3" {
    bucket      = "626037834880-terraform-states"
    key         = "backend/terraform.tfstate"
    region      = "us-west-2"
    encrypt     = true
    dynamodb_table = "terraform-lock"
  }

}

provider "aws" {}
 
# create s3 bucket

data "aws_caller_identity" "current" {}

locals { 
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform_state" {
  # with account id the name of the bucket can be globally unique
  bucket = "${local.account_id}-terraform-states"

} 

resource "aws_s3_bucket_versioning" "version-rule" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
   status = "Enabled"
  }
}

# creating s3 bucket server side encryption configuration
# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "terrform-s3-config" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

# create the dynamodb table

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

