provider "aws" {
    region = var.region_name
    }

resource "aws_launch_template" "test_launch_template" {
  name = "test-launch-template"
  image_id = var.ami_id
  instance_type = var.instance_type

  monitoring {
    enabled = true
  }
}

resource "aws_autoscaling_group" "test_asg" {
  name_prefix = "testasg"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = ["subnet-06f023e2d6e2f80e5", "subnet-0a42bee77d1da50bb"]

  health_check_type = "EC2"
 
  launch_template {
    id      = aws_launch_template.test_launch_template.id
    version = aws_launch_template.test_launch_template.latest_version
  }
 
  tag {
    key                 = "environmet"
    value               = "test"
    propagate_at_launch = true
  }      
}