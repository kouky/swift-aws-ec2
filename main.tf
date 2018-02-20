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
  
  user_data = <<-EOF
              #!/bin/bash
              echo "::Premptively add swift to path::"              
              echo "export PATH=/opt/swift/usr/bin:\"$${PATH}\"" >> /home/ubuntu/.bashrc
              
              echo "::apt-get update::"
              apt-get -y update
              
              echo "::apt-get upgrade::"
              # https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
              DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold"  install grub-pc
              apt-get -y upgrade
              
              echo "::Install Packages::"
              # https://bugs.swift.org/browse/SR-2743
              apt-get -y install clang libicu-dev libpython2.7 libcurl3
              
              echo "::Download + Install Swift::"
              wget -qO- https://swift.org/builds/swift-4.0.3-release/ubuntu1604/swift-4.0.3-RELEASE/swift-4.0.3-RELEASE-ubuntu16.04.tar.gz | tar xvz
              mv swift-4.0.3-RELEASE-ubuntu16.04 /opt/swift              
              # https://bugs.swift.org/browse/SR-2783
              chmod a+r /opt/swift/usr/lib/swift/CoreFoundation/*
              EOF
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
