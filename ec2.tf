# Instància EC2 amb la instal·lació del rocket chat
resource "aws_instance" "Servidor" {
  count = 3
  depends_on = [aws_internet_gateway.public_internet_gw]
  ami           = var.ami_ec2
  instance_type = var.instance_type_ec2
  key_name      = aws_key_pair.keypair.key_name
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.SG_public_subnet.id]
  tags = {
     Name = "Servidor-${count.index}"
  }
   user_data = templatefile("update.sh", {
   })

}
