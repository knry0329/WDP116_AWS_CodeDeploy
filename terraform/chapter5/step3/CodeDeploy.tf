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
  autoscaling_groups = ["wdb116"]
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = null
    }

    green_fleet_provisioning_option {
      action = "DISCOVER_EXISTING"
    }

    terminate_blue_instances_on_deployment_success {
      action = "KEEP_ALIVE"
    }
  }
  load_balancer_info {
    target_group_info {
      name = aws_alb_target_group.webapp.name
    }
  }
}