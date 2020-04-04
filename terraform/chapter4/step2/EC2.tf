# Get AMI Data
data "aws_ami" "wdb116" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["wdb116-ami*"]
  }
}

# EC2 for CodeDeploy Blue/Green (Blue)
resource "aws_instance" "webapp-codedeploy-1" {
  ami                    = data.aws_ami.wdb116.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.wdb116.0.id
  key_name               = "wdb116"
  vpc_security_group_ids = [aws_security_group.webapp.id]
  iam_instance_profile   = aws_iam_instance_profile.webapp.id
  tags = {
    Name = "wdb116-codedeploy-blue"
  }
  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

# EC2 for CodeDeploy Blue/Green (Green)
resource "aws_instance" "webapp-codedeploy-2" {
  ami                    = data.aws_ami.wdb116.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.wdb116.0.id
  key_name               = "wdb116"
  vpc_security_group_ids = [aws_security_group.webapp.id]
  iam_instance_profile   = aws_iam_instance_profile.webapp.id
  tags = {
    Name = "wdb116-codedeploy-green"
  }
  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}