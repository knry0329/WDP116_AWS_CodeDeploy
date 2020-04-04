# Get AMI Data
data "aws_ami" "wdb116" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["wdb116-ami*"]
  }
}

# Launch Template
resource "aws_launch_template" "webapp" {
  name          = "wdb116"
  instance_type = "t2.micro"
  image_id      = data.aws_ami.wdb116.id
  key_name      = "wdb116"
  iam_instance_profile {
    name = aws_iam_instance_profile.webapp.name
  }
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      "${aws_security_group.webapp.id}"
    ]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wdb116-codedeploy-autoscaling"
    }
  }
  lifecycle {
    ignore_changes = [
      default_version
    ]
  }
}
