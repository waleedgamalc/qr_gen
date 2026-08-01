data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ubuntu_server]
  }

  owners = [var.ubuntu_owner]
}

resource "aws_instance" "ec2_qr" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  security_groups = [var.sg_id]
  key_name = var.key_name
  subnet_id = var.subnet_id

  user_data = file(var.user_data)
}