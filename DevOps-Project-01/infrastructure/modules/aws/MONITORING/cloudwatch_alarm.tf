# CloudWatch Alarm for CPU > 50%
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 50

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}
