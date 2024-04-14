resource "aws_lb_target_group" "qoala" {
  name        = "qoala-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"  # Changed to HTTP
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.qoala.arn
  target_id        = var.instance_id
  port             = 80
}

resource "aws_lb" "qoala_lb" {
  name               = "qoala-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = [var.subnet_id, var.subnet_id_2]
}

resource "aws_lb_listener" "sh_front_end" {
  load_balancer_arn = aws_lb.qoala_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.qoala.arn
  }
}