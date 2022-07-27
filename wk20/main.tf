#Two Tier Architecture Project
#week20
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
#Depoly a VPC
resource "aws_vpc" "week20-vpc_block" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "week20-vpc_block"
  }
}
  
#Create 2 public Subnets
resource "aws_subnet" "subnet-public1" {
  vpc_id            = "aws_vpc.week20-vpc_block.id"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "Sub1"
  }
}

resource "aws_subnet" "subnet-public2" {
  vpc_id            = "aws_vpc.week20-vpc_block.id"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "Sub2"
  }
}
#create 2 private subnets
resource "aws_subnet" "subnet-private1" {
  vpc_id            = aws_vpc.week20-vpc_block.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Sub1priv"
  }
}

resource "aws_subnet" "subnet-private2" {
  vpc_id            = aws_vpc.week20-vpc_block.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Sub2priv"
  }
}

#Load Balancer
resource "aws_lb" "week20-lb" {
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-public1.id, aws_subnet.subnet-public2.id]

  enable_deletion_protection = false

  tags = {
    Name = "MainLB"
  }
}

#EC2 Instance
resource "aws_instance" "week20-instance1" {
  ami           = data.aws_instance.ec2_instance_ami
  subnet_id     = aws_subnet.subnet-public1
  instance_type = "t2.micro"
}

resource "aws_instance" "week20-instance2" {
  ami           = data.aws_instance.ec2_instance_ami
  subnet_id     = aws_subnet.subnet-public2
  instance_type = "t2.micro"
}