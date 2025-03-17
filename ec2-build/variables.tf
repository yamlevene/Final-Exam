variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "vpc_id" {
  default = "vpc-044604d0bfb707142"
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR notation to allow SSH and HTTP access (e.g., 203.0.113.1/32)"
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "AMI ID for Ubuntu image in us-east-1 az"
  type        = string
  default     = "ami-084568db4383264d4"
}
