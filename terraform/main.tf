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

resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web server security group"

  tags = {
    Environment = var.environment
    Owner       = var.owner
    CostCentre  = var.cost_centre
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.web.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = "terraform-demo"
    Environment = var.environment
    Owner       = var.owner
    CostCentre  = var.cost_centre
  }
}
