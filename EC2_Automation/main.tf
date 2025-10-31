# ----------------------------------------------------------
# Terraform configuration to launch an EC2 instance on AWS
# ----------------------------------------------------------

# Specify the Terraform provider
provider "aws" {
  region = "ap-south-1"  # Change region if needed (e.g., us-east-1)
}

# Create a new key pair (optional, or you can use an existing one)
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public SSH key
}

# Create a security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-0dee22c13ea7a9a67" # Example: Ubuntu 22.04 in ap-south-1 (Mumbai)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "My-Terraform-EC2"
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

