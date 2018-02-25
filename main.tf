# See https://www.terraform.io/docs/providers/aws/
provider "aws" {
  region = "us-west-1"
  profile = "terraform"
  version = "~> 1.9"
}

# See https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "swift-server" {
  ami = "ami-9cb2bdfc" /* Ubuntu 16.04 LTS https://cloud-images.ubuntu.com/locator/ec2/ */
  instance_type = "t2.micro" /* See https://aws.amazon.com/ec2/instance-types/ */
  vpc_security_group_ids = ["${aws_security_group.swift-server.id}"]
  key_name = "swift-server"
  tags {
    Name = "Swift Server"
  }
  user_data = "${file("user-data.sh")}"
}

/* See https://www.terraform.io/docs/providers/aws/r/security_group.html */
resource "aws_security_group" "swift-server" {
  name = "swift-server"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

/* See https://www.terraform.io/intro/getting-started/outputs.html */
output "public_ip" {
  value = "${aws_instance.swift-server.public_ip}"
}
