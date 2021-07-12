# ================================================= Target Group =================================================
resource "aws_lb_target_group" "targetGroup" {
  name             = "${var.TAG_NAME_PREFIX}TG"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"
  vpc_id           = var.ID_VPC

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 20
    matcher             = 200
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }
}

# ================================================= Load Balancer =================================================
resource "aws_lb" "load_balancer" {
  name                             = "${var.TAG_NAME_PREFIX}LB"
  load_balancer_type               = "application"
  internal                         = false
  security_groups                  = [var.SECURITY_GROUP__LB]
  ip_address_type                  = "ipv4"
  subnets                          = var.SUBNETS__PUBLIC
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false

  tags = {
    Name = "${var.TAG_NAME_PREFIX}LB"
  }
}

# ================================================= Load Balancer Listener =================================================
resource "aws_lb_listener" "load_balancer__listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.targetGroup.id
  }

  depends_on = [
    aws_lb.load_balancer,
    aws_lb_target_group.targetGroup
  ]
}
