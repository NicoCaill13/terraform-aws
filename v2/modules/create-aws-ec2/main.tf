
resource "aws_instance" "new_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  tags = {
    Name = var.name_tag
    slug = var.slug_tag
    env  = var.env_tag
  }
}

