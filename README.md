# asg_lc example 

This is an example set of Terraform modules attempting to reproduce [Terraform#13888](https://github.com/hashicorp/terraform/issues/13888)

Planning:

```
$ tf plan -out create.tfplan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Your plan was also saved to the path below. Call the "apply" subcommand
with this plan file and Terraform will exactly execute this execution
plan.

Path: create.tfplan

+ module.lc.aws_launch_configuration.aws_launch_configuration
    associate_public_ip_address: "false"
    ebs_block_device.#:          "<computed>"
    ebs_optimized:               "<computed>"
    enable_monitoring:           "true"
    image_id:                    "ami-dfc39aef"
    instance_type:               "t2.micro"
    key_name:                    "<computed>"
    name:                        "some_lc"
    root_block_device.#:         "<computed>"

+ module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group
    arn:                           "<computed>"
    availability_zones.#:          "1"
    availability_zones.2487133097: "us-west-2a"
    default_cooldown:              "<computed>"
    desired_capacity:              "<computed>"
    force_delete:                  "false"
    health_check_grace_period:     "300"
    health_check_type:             "<computed>"
    launch_configuration:          "some_lc"
    load_balancers.#:              "<computed>"
    max_size:                      "2"
    metrics_granularity:           "1Minute"
    min_size:                      "1"
    name:                          "some_lc"
    protect_from_scale_in:         "false"
    target_group_arns.#:           "<computed>"
    vpc_zone_identifier.#:         "<computed>"
    wait_for_capacity_timeout:     "10m"


Plan: 2 to add, 0 to change, 0 to destroy.
```

Saving the plan to graph:

```
$ tf graph create.tfplan | dot -Tpng create.png
```

Applying plan:

```
$ tf apply create.tfplan
module.lc.aws_launch_configuration.aws_launch_configuration: Creating...
  associate_public_ip_address: "" => "false"
  ebs_block_device.#:          "" => "<computed>"
  ebs_optimized:               "" => "<computed>"
  enable_monitoring:           "" => "true"
  image_id:                    "" => "ami-dfc39aef"
  instance_type:               "" => "t2.micro"
  key_name:                    "" => "<computed>"
  name:                        "" => "some_lc"
  root_block_device.#:         "" => "<computed>"
module.lc.aws_launch_configuration.aws_launch_configuration: Creation complete (ID: some_lc)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Creating...
  arn:                           "" => "<computed>"
  availability_zones.#:          "" => "1"
  availability_zones.2487133097: "" => "us-west-2a"
  default_cooldown:              "" => "<computed>"
  desired_capacity:              "" => "<computed>"
  force_delete:                  "" => "false"
  health_check_grace_period:     "" => "300"
  health_check_type:             "" => "<computed>"
  launch_configuration:          "" => "some_lc"
  load_balancers.#:              "" => "<computed>"
  max_size:                      "" => "2"
  metrics_granularity:           "" => "1Minute"
  min_size:                      "" => "1"
  name:                          "" => "some_lc"
  protect_from_scale_in:         "" => "false"
  target_group_arns.#:           "" => "<computed>"
  vpc_zone_identifier.#:         "" => "<computed>"
  wait_for_capacity_timeout:     "" => "10m"
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still creating... (10s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still creating... (20s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still creating... (30s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still creating... (40s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Creation complete (ID: some_lc)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Capturing the destroy plan:

```
$ tf plan -destroy -out=dest.tfplan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

aws_launch_configuration.aws_launch_configuration: Refreshing state... (ID: some_lc)
aws_autoscaling_group.aws_autoscaling_group: Refreshing state... (ID: some_lc)
The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Your plan was also saved to the path below. Call the "apply" subcommand
with this plan file and Terraform will exactly execute this execution
plan.

Path: dest.tfplan

- module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group

- module.lc.aws_launch_configuration.aws_launch_configuration


Plan: 0 to add, 0 to change, 2 to destroy.
```

Graphing the destroy plan:

```
$ tf graph dest.tfplan| dot -Tpng > destroy.png
```

Successfully destroying:

```
$ tf apply dest.tfplan
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Destroying... (ID: some_lc)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 10s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 20s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 30s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 40s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 50s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 1m0s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 1m10s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 1m20s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 1m30s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 1m40s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 1m50s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 2m0s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Still destroying... (ID: some_lc, 2m10s elapsed)
module.autoscaling_group.aws_autoscaling_group.aws_autoscaling_group: Destruction complete
module.lc.aws_launch_configuration.aws_launch_configuration: Destroying... (ID: some_lc)
module.lc.aws_launch_configuration.aws_launch_configuration: Destruction complete

Apply complete! Resources: 0 added, 0 changed, 2 destroyed.
```