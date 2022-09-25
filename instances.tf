#create A VPC

resource "aws_vpc" "Jenkins_Con" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Jenkins_Con"
  }
}

#create public subnet
resource "aws_subnet" "subnetpub1" {
  vpc_id     = aws_vpc.Jenkins_Con.id
  cidr_block = "10.0.1.0/26"

  tags = {
    Name = "subnetpub1"
  }
}

resource "aws_subnet" "subnetpub2" {
  vpc_id     = aws_vpc.Jenkins_Con.id
  cidr_block = "10.0.2.0/26"

  tags = {
    Name = "subnetpub2"
  }
}

#create private subnet
resource "aws_subnet" "subnetPri1" {
  vpc_id     = aws_vpc.Jenkins_Con.id
  cidr_block = "10.0.3.0/26"

  tags = {
    Name = "subnetpri1"
  }
}

resource "aws_subnet" "subnetPri2" {
  vpc_id     = aws_vpc.Jenkins_Con.id
  cidr_block = "10.0.4.0/26"

  tags = {
    Name = "subnetpri2"
  }
}


#create internet gateway
resource "aws_internet_gateway" "Jenkins_Con" {
  vpc_id = aws_vpc.Jenkins_Con.id
  tags = {
    Name = "Jenkins_Con"
  }

}
# Create EIP (within a vpc and with IGW dependency) 
resource "aws_eip" "Jenkins_Con" {
  vpc        = true
  depends_on = [aws_internet_gateway.Jenkins_Con]

  tags = {
    Name = "Jenkins_Con"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "Jenkins_Con" {
  allocation_id = aws_eip.Jenkins_Con.id
  subnet_id     = aws_subnet.subnetpub1.id
  depends_on    = [aws_internet_gateway.Jenkins_Con]

  tags = {
    Name = "Jenkins_Con"
  }
}

#Create Route Tables (public)
resource "aws_route_table" "Jenkins_Con_Pub" {
  vpc_id = aws_vpc.Jenkins_Con.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jenkins_Con.id
  }

  tags = {
    Name = "Jenkins_Con"
  }
}

# Create Route Table (Private)
resource "aws_route_table" "Jenkins_Con_Pri" {
  vpc_id = aws_vpc.Jenkins_Con.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Jenkins_Con.id
  }

  tags = {
    Name = "Jenkins_Con"
  }
}

#Assign Route Tables Associations

# Create Route Table Association for public subnet 
resource "aws_route_table_association" "Jenkins_Con_Pub" {
  subnet_id      = aws_subnet.subnetpub1.id
  route_table_id = aws_route_table.Jenkins_Con_Pub.id
}
# Create Route Table Association for private subnet
resource "aws_route_table_association" "Jenkins_Con_Pri" {
  subnet_id      = aws_subnet.subnetPri1.id
  route_table_id = aws_route_table.Jenkins_Con_Pub.id
}


#create security group
resource "aws_security_group" "Jenkins_Con" {
  name        = "Jenkins_Con"
  description = "allow ssh and http"
  vpc_id      = aws_vpc.Jenkins_Con.id

  ingress {
    description = "allow ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Proxy from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
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
  tags = {
    Name = "auto"
  }
}


#Create Keypair
resource "aws_key_pair" "testworld" {
  key_name   = "testworld"
  public_key = file("/Users/apple/Documents/DevOps Project/Containerisation-using-pipeline/Containerisation-project/testworld.pub")
}

#Provisioning of WebServers
resource "aws_instance" "SERVER1" {
  subnet_id                   = aws_subnet.subnetpub1.id
  vpc_security_group_ids      = ["${aws_security_group.Jenkins_Con.id}"]
  key_name                    = aws_key_pair.testworld.key_name
  instance_type               = "t2.micro"
  ami                         = "ami-018d291ca9ffc002f"
  associate_public_ip_address = true

  tags = {
    Name = "SERVER1"
  }
}

#Provisioning of WebServers
resource "aws_instance" "SERVER2" {
  subnet_id                   = aws_subnet.subnetpub1.id
  vpc_security_group_ids      = ["${aws_security_group.Jenkins_Con.id}"]
  key_name                    = aws_key_pair.testworld.key_name
  instance_type               = "t2.micro"
  ami                         = "ami-018d291ca9ffc002f"
  associate_public_ip_address = true

  tags = {
    Name = "SERVER2"
  }
}

#Provisioning of WebServers
resource "aws_instance" "SERVER3" {
  subnet_id                   = aws_subnet.subnetpub1.id
  vpc_security_group_ids      = ["${aws_security_group.Jenkins_Con.id}"]
  key_name                    = aws_key_pair.testworld.key_name
  instance_type               = "t2.micro"
  ami                         = "ami-018d291ca9ffc002f"
  associate_public_ip_address = true

  tags = {
    Name = "SERVER3"
  }
}

#Provisioning of WebServers
resource "aws_instance" "SERVER4" {
  subnet_id                   = aws_subnet.subnetpub1.id
  vpc_security_group_ids      = ["${aws_security_group.Jenkins_Con.id}"]
  key_name                    = aws_key_pair.testworld.key_name
  instance_type               = "t2.micro"
  ami                         = "ami-02ea247e531eb3ce6"
  associate_public_ip_address = true

  tags = {
    Name = "SERVER4"
  }
}
