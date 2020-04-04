# Get AWS Account ID
data "aws_caller_identity" "current" {}

# S3 for CodeDeploy revision
resource "aws_s3_bucket" "wdb116" {
  bucket = "wdb116-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}

# Output
output "bucket" {
  value = aws_s3_bucket.wdb116.bucket
}
