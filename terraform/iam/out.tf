output "iam_instance_profile" {
  description = "The ID of the VPC"
  value       = "${aws_iam_instance_profile.iam_instance_profile.id}"
}
