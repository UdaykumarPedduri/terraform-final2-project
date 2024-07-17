provider "aws" {
  region = "us-east-1"
  access_key = "AKIAZI2LD3XR6K6JW6CF"
  secret_key = "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"
}

resource "aws_instance" "webserver-one" {
  ami                    = "ami-036c2987dfef867fb"
  instance_type          = "t2.micro"
  key_name                = "jenkins_pra"
  vpc_security_group_ids = [aws_security_group.sg.id]
  availability_zone      = "us-east-1"


  user_data = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd -y
chkconfig httpd on
echo "hello world" > /var/www/html/index.html

EOF
  tags = {
    name = "terrraform - webserver-1"
  }
}

resource "aws_instance" "webserver-two" {
  ami                    = "ami-0ad21ae1d0696ad58"
  instance_type          = "t2.micro"
  key_name                = "jenkins_pra"
  vpc_security_group_ids = [aws_security_group.sg.id]
  availability_zone      = "ap-south-1"


  user_data = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd -y
chkconfig httpd on
echo "hello world" > /var/www/html/index.html

EOF
  tags = {
    name = "terraform - webserver-2"
  }
}

resource "aws_instance" "appserver-one" {
  ami                    = "ami-036c2987dfef867fb"
  instance_type          = "t2.micro"
  key_name                = "jenkins_pra"
  vpc_security_group_ids = [aws_security_group.sg.id]
  availability_zone      = "us-east-1"
  tags = {
    name = "terraform-appserver-1"
  }
}

resource "aws_instance" "appserver-two" {
  ami                    = "ami-0ad21ae1d0696ad58"
  instance_type          = "t2.micro"
  key_name                = "jenkins_pra"
  vpc_security_group_ids = [aws_security_group.sg.id]
  availability_zone      = "ap-south-1"
  tags = {
    name = "terraform-appserver-2"
  }
}


resource "aws_security_group" "sg" {
  name = "elb-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_s3_bucket" "s3" {
  bucket = "terraformprojects3bucket"
}

resource "aws_iam_user" "iamuser" {
  name = "terraiamuser"
}

resource "aws_ebs_volume" "vol" {
  availability_zone = "ap-south-1b"
  size              = 40
  tags = {
    name = "ebs-001"
  }
}





