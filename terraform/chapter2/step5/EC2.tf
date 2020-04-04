# Get AMI Data
data "aws_ami" "wdb116" {
  most_recent = true
  owners = ["self"]
  filter {
    name   = "name"
    values = ["wdb116-ami*"]
  }  
}
