##########################################
##### SSH KEY PAIR #######################
##########################################

resource "aws_key_pair" "ec2_key" {
  key_name = "${var.name}-keypair"
  public_key = "${file(var.ssh_public_key_location)}"
}