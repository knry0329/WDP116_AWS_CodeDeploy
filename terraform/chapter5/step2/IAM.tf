# IAM Role for EC2
resource "aws_iam_role" "webapp" {
  name = "wdb116-webapp"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# IAM Policy for CodeDeploy
resource "aws_iam_role_policy" "codedeploy" {
  name   = "wdb116-codedeploy"
  role   = aws_iam_role.webapp.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.wdb116.arn}/*",
        "arn:aws:s3:::aws-codedeploy-us-east-1/*"
      ]
    }
  ]
}
POLICY
}

# Instance profile
resource "aws_iam_instance_profile" "webapp" {
  name = "wdb116-webapp"
  role = aws_iam_role.webapp.name
}

# IAM Role for CodeDeploy
resource "aws_iam_role" "codedeploy" {
  name               = "codedeploy"
  path               = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      }
    }
  ]
}
POLICY
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}

# IAM Role Policy for CodeDeploy Autoscaling
resource "aws_iam_role_policy" "codedeploy-autoscaling" {
  name   = "codedeploy-autoscaling"
  role   = aws_iam_role.codedeploy.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:PassRole",
        "ec2:CreateTags",
        "ec2:RunInstances",
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DeleteLifecycleHook",
        "autoscaling:DescribeLifecycleHooks",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:PutLifecycleHook",
        "autoscaling:RecordLifecycleActionHeartbeat"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}
