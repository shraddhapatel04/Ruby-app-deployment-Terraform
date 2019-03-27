# resource "aws_security_group" "sg" {
#   name        = "${var.name}-bastion"
#   description = "Allow SSH inbound traffic"
#   vpc_id      = "${var.vpc_id}"
#   count             = "${length(split(",", var.sg_ports))}"
#   ingress {
#     # TLS (change to whatever ports you need)
#     from_port   = "${element(split(",", var.sg_ports), count.index)}"
#     to_port     = "${element(split(",", var.sg_ports), count.index)}"
#     protocol    = "${element(split(",", var.protocol), count.index)}"
#     # Please restrict your ingress to only necessary IPs and ports.
#     # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
#     cidr_blocks = "${var.cidr}"# add a CIDR block here
#   }

#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }
# }
#######################################################################
## Security Group and rules creation
#######################################################################
resource "aws_security_group" "sg" {
  name        = "${var.name}"
  description = "${var.name}"

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All egress traffic"
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress" {
  count             = "${length(split(",", var.sg_ports))}"
  type              = "ingress"
  from_port         = "${element(split(",", var.sg_ports), count.index)}"
  to_port           = "${element(split(",", var.sg_ports), count.index)}"
  protocol          = "tcp"
  cidr_blocks       = "${var.cidr}"
  description       = ""
  security_group_id = "${aws_security_group.sg.id}"
}