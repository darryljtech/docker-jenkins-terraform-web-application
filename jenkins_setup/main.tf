terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
  }
}

# Create S3 bucket where backend configuration file will be hosted

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-jenkins-docker-backend-bucket-3895489"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

# Create security group for Docker Jenkins EC2 instance

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Open ports required for Jenkins to run"

  tags = {
    Name = "jenkins_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_sg_ipv4" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_sg_jenkins" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_sg_ssh" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_sg_http" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


##### Create EC2 instance to run docker container hosting Jenkins

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "docker_jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.large"
  user_data                   = base64encode(file("${path.module}/docker_user_data.sh"))
  associate_public_ip_address = true
  key_name                    = "cicd_key_pair"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Docker-Jenkins"
  }
}