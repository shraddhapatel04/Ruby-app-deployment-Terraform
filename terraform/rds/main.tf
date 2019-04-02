
# resource "aws_rds_cluster" "rds" {
#   cluster_identifier      = "${var.name}"
#   database_name           = "${var.name}"
#   master_username         = "${var.user}"
#   master_password         = "${var.password}"
#   engine                  = "aurora-mysql"
#   backup_retention_period = 5
#   db_subnet_group_name = "${aws_db_subnet_group.private_sng.id}"
#   vpc_security_group_ids = ["${aws_security_group.rds-sg.id}"]
#   apply_immediately      = true

#   tags = {
#       Name = "${var.name}"
#   }
# }

resource "aws_db_instance" "rds" {
  count                   = 1
  identifier              = "${var.name}-${count.index}"
#   cluster_identifier      = "${aws_rds_cluster.rds.id}"
  name                                = "${var.name}"
  username                            = "${var.user}"
  password                            = "${var.password}"
  engine                  = "mysql"
  instance_class          = "db.t2.medium"
  apply_immediately       = true
  multi_az = true
  db_subnet_group_name = "${aws_db_subnet_group.private_sng.id}"
  vpc_security_group_ids = ["${aws_security_group.rds-sg.id}"]
  allocated_storage = 5
  backup_retention_period = 5
  final_snapshot_identifier = "${var.name}-final"
  skip_final_snapshot  = true
  tags = {
      Name = "${var.name}"
  }
}

resource "aws_db_subnet_group" "private_sng" {
  name        = "${var.name}-private"
  description = "Subnet group for RDS"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = {
      Name = "${var.name}-private"
   }
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  tags = {
      Name = "${var.name}" 
  }
}

