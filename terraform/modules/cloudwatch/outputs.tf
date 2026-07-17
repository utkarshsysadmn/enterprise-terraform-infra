output "cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu.alarm_name
}

output "memory_alarm_name" {
  value = aws_cloudwatch_metric_alarm.memory.alarm_name
}

output "disk_alarm_name" {
  value = aws_cloudwatch_metric_alarm.disk.alarm_name
}

output "status_alarm_name" {
  value = aws_cloudwatch_metric_alarm.status_check.alarm_name
}