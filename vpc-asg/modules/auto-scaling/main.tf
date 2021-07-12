
# ================================================= Launch Configuration =================================================
resource "aws_launch_configuration" "launchConfig" {
  name              = "${var.TAG_NAME_PREFIX}launchConfig"
  image_id          = var.INSTANCE.AMI
  instance_type     = var.INSTANCE.TYPE
  security_groups   = [var.SECURITY_GROUP__PUBLIC]
  user_data         = data.template_file.userData.rendered
  key_name          = var.INSTANCE.KEY
  enable_monitoring = false

  depends_on = [var.DEPENDENCIES]
}

# ================================================= Auto Scaling Group =================================================
resource "aws_autoscaling_group" "auto_scaling_group" {
  name                      = "${var.TAG_NAME_PREFIX}ASG"
  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 4
  health_check_grace_period = 60
  health_check_type         = "EC2"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.launchConfig.name
  vpc_zone_identifier       = var.SUBNETS__PUBLIC
  target_group_arns         = [var.TARGET_GROUP__ARN]

  tag {
    key                 = "Name"
    value               = "${var.TAG_NAME_PREFIX}PUBLIC-instance"
    propagate_at_launch = true
  }

  depends_on = [
    aws_launch_configuration.launchConfig
  ]
}

# ================================================= Policy - Auto Scaling Group =================================================
resource "aws_autoscaling_policy" "policy_autoScalingGroup" {
  name                    = "${var.TAG_NAME_PREFIX}target-tracking-policy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
  autoscaling_group_name  = aws_autoscaling_group.auto_scaling_group.name
}







# ================================================= userData.sh =================================================
data "template_file" "userData" {
  template = file("userData.sh")
  vars = {
    OBJ_URL = "${var.OBJ_URL}"
    FILE    = split("/", var.OBJ_URL)[3] # extracting file
    HOST    = "${var.PRIVATE_INSTANCE}"
  }
}
