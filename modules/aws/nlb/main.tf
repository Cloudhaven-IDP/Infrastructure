data "aws_subnet" "selected" {
  id = element(var.subnet_ids, 0)
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}

resource "aws_eip" "this" {
  count = var.create_eips ? length(var.subnet_ids) : 0
}

resource "aws_lb" "this" {
  name               = "${var.name}-lb"
  internal           = var.internal
  load_balancer_type = var.type
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  dynamic "subnet_mapping" {
    for_each = aws_eip.this
    content {
      subnet_id     = var.subnet_ids[tonumber(subnet_mapping.key)]
      allocation_id = subnet_mapping.value.id
    }
  }

  tags = merge({
    Name = "${var.name}-lb"
  }, var.tags)
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = var.port
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_id
  port             = var.port
}
