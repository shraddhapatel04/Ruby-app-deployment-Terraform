resource "aws_iam_role" "iam_role" {
  name = "${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      Name = "${var.name}"
  }
}

data "template_file" "iam_role_policy_template" {
  template = "${file("${var.iamrole_template}")}"
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name   = "${var.name}"
  role   = "${aws_iam_role.iam_role.name}"
  policy = "${data.template_file.iam_role_policy_template.rendered}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${var.name}"
  role = "${aws_iam_role.iam_role.name}"
}