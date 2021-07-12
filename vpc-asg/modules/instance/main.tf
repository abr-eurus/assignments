
# ================================================= Instance (Private) =================================================
resource "aws_instance" "instance_private" {
  ami                    = var.INSTANCE.AMI
  instance_type          = var.INSTANCE.TYPE
  vpc_security_group_ids = [var.SECURITY_GROUP__PRIVATE]
  key_name               = var.INSTANCE.KEY
  subnet_id              = var.SUBNET__PRIVATE
  availability_zone      = var.AZs[0]
  user_data              = file("userData_private_instance.sh")

  tags = {
    Name = "${var.TAG_NAME_PREFIX}PRIVATE-instance"
  }
}

# ================================================= Instance (Public) =================================================
# resource "aws_instance" "instance_public" {
#   ami                    = var.INSTANCE.AMI
#   instance_type          = var.INSTANCE.TYPE
#   vpc_security_group_ids = [var.SECURITY_GROUP__PUBLIC]
#   key_name               = var.INSTANCE.KEY
#   subnet_id              = var.SUBNETS__PUBLIC[0]
#   availability_zone      = var.AZs[1]
#   user_data              = data.template_file.userData.rendered

#   tags = {
#     Name = "${var.TAG_NAME_PREFIX}PUBLIC-instance"
#   }

#   depends_on = [var.DEPENDENCIES]
# }


# ================================================= userData.sh =================================================
# data "template_file" "userData" {
#   template = file("userData.sh")
#   vars = {
#     OBJ_URL = "${var.OBJ_URL}"
#     FILE    = split("/", var.OBJ_URL)[3] # extracting file
#     HOST    = "${aws_instance.instance_private.private_ip}"
#   }
# }
