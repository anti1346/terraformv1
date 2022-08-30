output "elastic_ip" {
  description = "Elastic IP of Instance"
  value       = aws_eip.my_eip.public_ip
}