# SG for ELB
resource "aws_security_group" "elb" {
  name        = "wdb116-elb"
  description = "wdb116-elb"
  vpc_id      = aws_vpc.wdb116.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "wdb116"
  }
}

# SG for EC2
resource "aws_security_group" "webapp" {
  name        = "wdb116-webapp"
  description = "wdb116-webapp"
  vpc_id      = aws_vpc.wdb116.id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    description     = "HTTP"
    security_groups = ["${aws_security_group.elb.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "wdb116"
  }
}
