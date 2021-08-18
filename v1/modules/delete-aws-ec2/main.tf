resource "null_resource" "delete"{
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${var.instance}"
  }
}