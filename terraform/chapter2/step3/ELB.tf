# ELB (Application Load Balancer)
resource "aws_alb" "webapp" {
  name     = "wdb116-elb"
  internal = false
  security_groups = [
    "${aws_security_group.elb.id}",
  ]
  subnets = ["${aws_subnet.wdb116.0.id}", "${aws_subnet.wdb116.1.id}"]
  tags = {
    Name = "wdb116"
  }
}

# Listener
resource "aws_alb_listener" "webapp-http" {
  load_balancer_arn = aws_alb.webapp.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.webapp.arn
    type             = "forward"
  }
}

# Target Group
resource "aws_alb_target_group" "webapp" {
  name                 = "wdb116-webapp"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.wdb116.id
  slow_start           = 0
  deregistration_delay = 0
  health_check {
    interval            = 5
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}

# Output
output "dns_name" {
  value = aws_alb.webapp.dns_name
}

output "target_group_arn" {
  value = aws_alb_target_group.webapp.arn
}
