variable "aws_region" {
  description = "AWS region where EC2 will be created"
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