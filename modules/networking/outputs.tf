output "instance_public_ip" {
  description = "L'adresse publique de notre instance"
  value       = aws_eip.public_ip.public_ip
}
