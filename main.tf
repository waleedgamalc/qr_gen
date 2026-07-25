provider "aws" {

    region = "eu-central-1"
}

resource "aws_vpc" "qr_vpc" {

    region = "eu-central-1"
    cidr_block = "10.0.0.0/16"
    
    
  
}


resource "aws_subnet" "public_subnet" {

    vpc_id = aws_vpc.qr_vpc.id
    cidr_block = "10.0.1.0/24"
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



resource "aws_security_group" "qr_app_sg" {
  name        = "qr_app_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.qr_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {

    security_group_id = aws_security_group.qr_app_sg.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 5000
    ip_protocol       = "tcp"
    to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    
    security_group_id = aws_security_group.qr_app_sg.id
    cidr_ipv4         = "197.45.49.33/32"
    from_port         = 22
    ip_protocol       = "tcp"
    to_port           = 22
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
    security_group_id = aws_security_group.qr_app_sg.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1" 
}





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

  owners = ["099720109477"]
}


resource "aws_key_pair" "qr_key" {
  key_name   = "qr-app-key"
  public_key = file("/home/waleed/Desktop/qr-code-api/qr-app-key.pub") 
}

resource "aws_instance" "ec2_qr" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  security_groups = [aws_security_group.qr_app_sg.id]
  key_name = aws_key_pair.qr_key.key_name
  subnet_id = aws_subnet.public_subnet.id

  user_data = file("/home/waleed/Desktop/qr-code-api/userdata.sh")
}
