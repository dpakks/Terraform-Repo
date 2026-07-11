terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ---------------- Networking (needed to deploy EC2) ----------------

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
    Name      = "${var.instance_name}-subnet"
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

# ---------------- S3: primary bucket (private baseline) ----------------

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "data" {
  bucket = "${var.s3_bucket_prefix}-${random_id.bucket_suffix.hex}"

  tags = {
    ManagedBy = "TerraGuard"
    Name      = "${var.instance_name}-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs" {
  bucket = "terraguard-logs-5401ea61"

  tags = {
    ManagedBy = "TerraGuard"
    Name      = "basic-ec2-logs-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_id" "logs_bucket_suffix" {
  byte_length = 4
}