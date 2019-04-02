output "lb_endpoint" {
    value = "${aws_elb.applb.dns_name}"
}