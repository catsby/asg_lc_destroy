variable "name" {}
variable "image_id" {}
variable "instance_type" {}

resource "aws_launch_configuration" "aws_launch_configuration" {
  name          = "${var.name}"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
}
