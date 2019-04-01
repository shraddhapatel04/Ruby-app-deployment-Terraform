resource "aws_elb" "applb" {
  name            = "${var.name}"
  security_groups = ["${var.sg_id}"]
  subnets         = ["${slice(var.public_subnets, 0, 2)}"]
  idle_timeout    = 4000

  health_check = {
    target              = "HTTP:80/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
  }

  listener = {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  tags = {
      Name = "${var.name}"
  }
}

resource "aws_autoscaling_attachment" "applb" {
  elb                    = "${aws_elb.applb.id}"
  autoscaling_group_name = "${var.asg_id}"
}