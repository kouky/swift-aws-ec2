provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "swift-server" {
  ami = "ami-9cb2bdfc" # Ubuntu 16.04 LTS https://cloud-images.ubuntu.com/locator/ec2/
  instance_type = "t2.nano"
  vpc_security_group_ids = ["${aws_security_group.swift-server.id}"]
  key_name = "swift"
  tags {
    Name = "Swift Server"
  }
  user_data = "${file("user-data.sh")}"
}

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

/* Output */
output "public_ip" {
  value = "${aws_instance.swift-server.public_ip}"
}
