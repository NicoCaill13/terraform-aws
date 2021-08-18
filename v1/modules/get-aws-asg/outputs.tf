output "launchConfiguration" {
  value = data.aws_autoscaling_group.asg.launch_configuration
}
output "autoscalingName" {
  value = data.aws_autoscaling_group.asg.name
}
output "autoscalingVpc" {
  value = data.aws_autoscaling_group.asg.vpc_zone_identifier
}
output "launchConfigurationName"{
  value = data.local_file.launch_configuration_name.content
}
output "launchConfigurationSG"{
  value = data.aws_launch_configuration.asg.security_groups
}
output "ebsBlockDevice"{
  value = data.aws_launch_configuration.asg.ebs_block_device
}