variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "basic-ec2"
}

variable "instance_type" {
  description = "EC2 instance type (policy requires t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-2a"
}

variable "s3_bucket_prefix" {
  description = "Prefix for the primary S3 bucket name (random suffix appended for uniqueness)"
  type        = string
  default     = "terraguard-demo"
}

variable "logs_bucket_prefix" {
  description = "Prefix for the additional (logs) S3 bucket name (random suffix appended for uniqueness)"
  type        = string
  default     = "terraguard-logs"
}
