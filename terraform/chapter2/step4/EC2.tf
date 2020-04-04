# Get AMI Data
data "aws_ami" "wdb116" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["wdb116-ami*"]
  }
}

# EC2 for Chapter 2
resource "aws_instance" "webapp" {
  ami                    = data.aws_ami.wdb116.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.wdb116.0.id
  key_name               = "wdb116"
  vpc_security_group_ids = [aws_security_group.webapp.id]
  tags = {
    Name = "wdb116"
  }
  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

# Output
output "public_ip" {
  value = aws_instance.webapp.public_ip
}

output "instance_id" {
  value = aws_instance.webapp.id
}
