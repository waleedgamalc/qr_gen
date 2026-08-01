resource "aws_key_pair" "qr_key" {
  key_name   = "qr-app-key"
  public_key = file(var.key_pair_path) 
}