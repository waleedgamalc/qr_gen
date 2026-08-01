resource "aws_vpc" "qr_vpc" {

    region = "eu-central-1"
    cidr_block = var.vpc_cidr
  
}


resource "aws_subnet" "public_subnet" {

    vpc_id = aws_vpc.qr_vpc.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true

  
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.qr_vpc.id

}



resource "aws_route_table" "rt_public_sub" {
  vpc_id = aws_vpc.qr_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_public_sub.id
}