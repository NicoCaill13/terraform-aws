output "elbArn"{
  value = (var.nbTarget == "1") ? data.aws_lb_target_group.target[0].arn :  join(",", data.aws_lb_target_group.target.*.arn)
}

output "testAws"{
 value = data.external.example
}

output "arn"{
  value = split("," , join(",", data.aws_lb_target_group.target.*.arn))
}