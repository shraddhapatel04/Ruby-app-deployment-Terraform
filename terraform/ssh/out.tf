output "ec2_key_name" {
  description = "The ssh key to used while creating instances"
  value       = "${aws_key_pair.ec2_key.key_name}"
}