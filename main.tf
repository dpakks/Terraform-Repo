terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ---------------- Minimal networking (needed to deploy EC2) ----------------

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    ManagedBy = "TerraGuard"
    Name      = "${var.instance_name}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    ManagedBy = "TerraGuard"
    Name      = "${var.instance_name}-subnetttt"
  }
}

# ---------------- EC2 ----------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id

  tags = {
    ManagedBy = "TerraGuard"
    Name      = var.instance_name
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-private-bucket"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    ManagedBy = "TerraGuard"
  }
}