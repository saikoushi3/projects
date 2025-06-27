# main.tf - Infrastructure for a custom K8s cluster

# --- Provider & Backend Configuration ---
provider "aws" {
  region = "us-east-1" # You can change the region
}


# --- Data Sources ---
data "aws_availability_zones" "available" {}

# --- VPC ---
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Project1-Custom-K8s-VPC"
  }
}

# --- Subnets ---
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Project1-Public-Subnet"
  }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Project1-IGW"
  }
}

# --- Route Table ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "Project1-Public-RT"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --- Security Groups ---
# Security Group for K8s Master Node
resource "aws_security_group" "k8s_master" {
  name        = "project1-k8s-master-sg"
  description = "Security group for K8s master node"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Kube-API server access from anywhere (for kubectl)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all traffic from within the VPC (for worker nodes)
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Project1-K8s-Master-SG" }
}

# Security Group for K8s Worker Nodes
resource "aws_security_group" "k8s_worker" {
  name        = "project1-k8s-worker-sg"
  description = "Security group for K8s worker nodes"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow NodePort traffic from anywhere
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic from within the VPC (for master and other workers)
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Project1-K8s-Worker-SG" }
}


# Jenkins EC2 Security Group
resource "aws_security_group" "jenkins" {
  name        = "project1-jenkins-sg"
  description = "Allow traffic to Jenkins server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = { Name = "Project1-Jenkins-SG" }
}



# Jenkins Server
resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name      = var.key_name
  tags          = { Name = "Project1-Jenkins-Server" }
}

# Kubernetes Master Node
resource "aws_instance" "k8s_master" {
  ami           = var.ami_id
  instance_type = "t3.medium" # t3.medium or larger recommended
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k8s_master.id]
  key_name      = var.key_name
  tags          = { Name = "Project1-K8s-Master" }
}

# Kubernetes Worker Nodes
resource "aws_instance" "k8s_worker" {
  count         = 2 # Creating 2 worker nodes
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k8s_worker.id]
  key_name      = var.key_name
  tags          = { Name = "Project1-K8s-Worker-${count.index + 1}" }
}


