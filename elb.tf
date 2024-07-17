resource "aws_elb" "bar" {
  name              = "uday-terraform-elb"
  availability_zone = ["ap-south-1a", "ap-south-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = ["${aws_instance.webserver-one.id}", "${aws_instance.webserver-two.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 400
  tags = {
    name = "uday-tf-elb"
  }
}
