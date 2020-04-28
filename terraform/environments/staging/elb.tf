resource "aws_elb" "this" {
  name                = local.project_name-environment
  subnets             = var.default_subnet_ids
  connection_draining = true
  security_groups     = [aws_security_group.load_balancer.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:8080/health"
    timeout             = 5
    interval            = 60
    unhealthy_threshold = 10
    healthy_threshold   = 2
  }
}
