

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
    Owner       = var.owner
    CostCentre  = var.cost_centre
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = "terraform-demo"
    Environment = var.environment
    Owner       = var.owner
    CostCentre  = var.cost_centre
  }
}