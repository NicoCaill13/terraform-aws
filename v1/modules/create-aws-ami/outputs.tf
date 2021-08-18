output "amiId"{
  value = element(aws_ami_from_instance.ami.*.id, 0)
}