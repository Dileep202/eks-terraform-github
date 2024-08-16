locals {
  cluster-name= var.cluster_name
}

resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"

    tags = {
        name = var.vpc-name
        env = var.env
    }
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc_for_eks.id

    tags = {
      name = var.igw-name
      env =  var.env
      "kubernetes.io/cluster/${local.cluster-name}" = "owned"
    }

    depends_on = [ aws_vpc.vpc]
}

resource "aws_internet_gateway_attachment" "igw-attach" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id = aws_vpc.vpc_for_eks.id
}

resource  "aws_subnet"  "public-subnet" {
 count                   = var.pub-subnet-count
 vpc_id                  = aws_vpc.vpc.id 
 cidr_block              = element(var.pub-cidr-block, count.index) 
 availability_zone       = element(var.pub-availability-zone, count.index) 
 map_public_ip_on_launch = true 
 tags = { 
 Name                                          = "${var.pub-sub-name}-${count.index + 1}" 
 Env                                           =  var.env 
 "kubernetes.io/cluster/${local.cluster-name}" = "owned" 
 "kubernetes.io/role/elb"                      = "1" 
 }

 depends_on = [aws_vpc.vpc]
}


resource "aws_subnet" "private-subnet" {
  count             = var.priv-subnet-count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.priv-cidr-block, count.index)
  availability_zone = element(var.priv-availability-zone, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name                                          = "${var.priv-sub-name}-${count.index + 1}"
    Env                                           =  var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1"
  }
  depends_on = [aws_vpc.vpc]
  
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.pub-rt-name
    Env = var.env
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet_association" "name" {
  count = var.pub-subnet-count
  subnet_id = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
  depends_on = [aws_route_table.public-route-table]
}


resource "aws_eip" "nat-gw-eip" {
  domain = vpc
  tags = {
    Name = "${var.nat-gw-eip-name}"
    Env = var.env
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = aws_subnet.public-subnet[0].id
  tags = {
    Name = "${var.ngw-name}"
    Env = var.env
  }
  depends_on = [aws_eip.nat-gw-eip]
  
}

resource "aws_private_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = var.priv-rt-name
    Env = var.env
  }
  
}

resource "aws_private_route_table_association" "aws_private_route_table_association" {
  count = var.priv-subnet-count
  subnet_id = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_private_route_table.private-route-table.id
  depends_on = [aws_private_route_table.private-route-table]
  
}

 resource  "aws_security_group"  "eks-cluster-sg"  { 
 name        = var.eks-sg 
 description = "Allow 443 from Jump Server only" 
 vpc_id = aws_vpc.vpc.id 
 ingress { 
 from_port   = 443 
 to_port     = 443 
 protocol    = "tcp" 
 cidr_blocks = ["0.0.0.0/0"] // It should be specific IP range 
 } 
 egress { 
 from_port   = 0 
 to_port     = 0 
 protocol    = "-1" 
 cidr_blocks = ["0.0.0.0/0"] 
 } 
 tags = { 
 Name = var.eks-sg 
 } 
 }







