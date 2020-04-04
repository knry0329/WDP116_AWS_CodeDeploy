# CodeDeploy Application
resource "aws_codedeploy_app" "webapp" {
  compute_platform = "Server"
  name             = "wdb116-webapp"
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "webapp" {
  app_name               = aws_codedeploy_app.webapp.name
  deployment_group_name  = "develop"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "wdb116-codedeploy"
    }
  }
  load_balancer_info {
    target_group_info {
      name = aws_alb_target_group.webapp.name
    }
  }
}