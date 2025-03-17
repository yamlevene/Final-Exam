provider "aws" {
  region = var.region
}

# Generate an SSH key pair
resource "tls_private_key" "yam_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key locally (chmod 600 equivalent)
resource "local_file" "private_key" {
  content         = tls_private_key.yam_ssh_key.private_key_pem
  filename        = "${path.module}/builder_key.pem"
  file_permission = "0600"
}

# Create AWS key pair with the public key
resource "aws_key_pair" "builder_key" {
  key_name   = "builder-key"
  public_key = tls_private_key.yam_ssh_key.public_key_openssh
}

# Security group for SSH (22) and HTTP (5001)
resource "aws_security_group" "yam_builder_sg" {
  name        = "yam-builder-sg"
  description = "Allow SSH and HTTP (5001)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ip_cidr
  }

  ingress {
    description = "Allow HTTP 5001"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = var.my_ip_cidr
  }

  ingress {
    description = "Allow HTTP 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.my_ip_cidr
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "yam-builder-sg"
  }
}

# Get all subnets in the VPC
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# EC2 instance
resource "aws_instance" "builder" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.public_subnets.ids[0]
  key_name                    = aws_key_pair.builder_key.key_name
  vpc_security_group_ids      = [aws_security_group.yam_builder_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "builder"
  }
}
