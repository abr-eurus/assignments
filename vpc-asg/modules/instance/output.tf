output "IP_instance_private" {
  value = aws_instance.instance_private.private_ip
}

output "instance_private" {
  value = aws_instance.instance_private
}

# output "instance_public" {
#   value = "${aws_instance.instance_public.public_ip} (public IP)"
# }