# Instància EC2 amb la instal·lació d'Ansible
resource "aws_instance" "Ansible" {
  depends_on = [aws_internet_gateway.public_internet_gw]
  ami           = var.ami_ec2
  instance_type = var.instance_type_ec2
  key_name      = aws_key_pair.keypair.key_name
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.SG_public_subnet.id]
  tags = {
     Name = "Ansible"
  }

   user_data = templatefile("ansible.sh", {
    ipsrv0 = "${aws_instance.Servidor[0].public_ip}"
    ipsrv1 = "${aws_instance.Servidor[1].public_ip}"
    ipsrv2 = "${aws_instance.Servidor[2].public_ip}"

  })
  provisioner "file" {
    source      = "~/Ansibledemo/mykey"
    destination = "mykey"
    

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    private_key = "${file("mykey")}"
    host        = self.public_ip
  }
  }
}
