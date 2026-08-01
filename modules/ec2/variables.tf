variable "ubuntu_server" {

    default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  
}
variable "ubuntu_owner" {

    default = "099720109477"
  
}


variable "user_data" {

    default = "/home/waleed/Desktop/qr-code-api/userdata.sh"
  
}

variable "sg_id" {
    type = string
  
}


variable "key_name" {
    type = string
  
}
variable "subnet_id" {
    type = string
  
}


