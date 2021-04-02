
#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.TFmain.id}"

  tags = {
    Name = "TFmain"
  }
}
#VPC
resource "aws_vpc" "TFmain" {
  cidr_block       = "11.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TFmain"
  }
}

#Public Subnet

resource "aws_subnet" "TFPublic" {
  vpc_id     = "${aws_vpc.TFmain.id}"
  cidr_block = "11.0.1.0/24"

  tags = {
    Name = "TFPublic"
  }
}

#Private Subnet

resource "aws_subnet" "TFPrivate1" {
  vpc_id     = "${aws_vpc.TFmain.id}"
  cidr_block = "11.0.2.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "TFPrivate1"
  }
}

resource "aws_subnet" "TFPrivate2" {
  vpc_id     = "${aws_vpc.TFmain.id}"
  cidr_block = "11.0.3.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "TFPrivate2"
  }
}


#resource "aws_db_subnet_group" "default" {
 # name       = "main"
  #subnet_ids = [aws_subnet.TFPrivate2.id, aws_subnet.TFPrivate2.id]
  #vpc_id = "${aws_vpc.TFmain.id}"
  #tags = {
   # Name = "My DB subnet group"
  #}

#}

#Subnet Association
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.TFPublic.id}"
  route_table_id = "${aws_route_table.TFPublicRTB.id}"
}

#PublicRTB

resource "aws_route_table" "TFPublicRTB" {
  vpc_id = "${aws_vpc.TFmain.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }		

  tags = {
    Name = "TFPublicRTB"
  }
}

#Subnet Association TFPrivate1

resource "aws_route_table_association" "b" {
  subnet_id	 = "${aws_subnet.TFPrivate1.id}"
  route_table_id = "${aws_route_table.TFPrivateRTB.id}"
}

#Subnet Association TFPrivate2

resource "aws_route_table_association" "c" {
  subnet_id      = "${aws_subnet.TFPrivate2.id}"
  route_table_id = "${aws_route_table.TFPrivateRTB.id}"
}

#PrivateRTB

resource "aws_route_table" "TFPrivateRTB" {
  vpc_id = "${aws_vpc.TFmain.id}"


  tags = {
    Name = "TFPrivateRTB"
  }
}
##Creating An Elastic IP for NAT Gateway

resource "aws_eip" "elastic-ip-for-nat-gw" {
    vpc = true
    associate_with_private_ip = "11.0.2.5"
        tags = {
            Name = "Production-EIP"
            }
}

##Creating the NAT GateWay and Adding to Route Table

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = "${aws_eip.elastic-ip-for-nat-gw.id}"
    subnet_id = "${aws_subnet.TFPublic.id}"
        tags = {
            Name = "Production-NAT-GW"
            }
}

resource "aws_route" "nat-gw-route" {
    route_table_id = "${aws_route_table.TFPrivateRTB.id}"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
    destination_cidr_block = "0.0.0.0/0"
}
