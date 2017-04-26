# Example assume us-west-2 region

module "autoscaling_group" {
  source               = "./modules/asg"
  name                 = "${module.lc.name}"
  launch_configuration = "${module.lc.name}"
  min_size             = 1
  max_size             = 2
  az                   = "us-west-2a"
}

module "lc" {
  source = "./modules/lc"

  name          = "some_lc"
  image_id      = "ami-dfc39aef"
  instance_type = "t2.micro"
}
