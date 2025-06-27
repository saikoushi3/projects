# --- Outputs ---
output "jenkins_server_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_server_private_ip" {
  value = aws_instance.jenkins_server.private_ip
}

output "k8s_master_public_ip" {
  value = aws_instance.k8s_master.public_ip
}

output "k8s_worker_public_ips" {
  value = aws_instance.k8s_worker.*.public_ip
}

output "k8s_worker_private_ips" {
  value = aws_instance.k8s_worker.*.private_ip
}

output "k8s_master_private_ip" {
  value = aws_instance.k8s_master.private_ip
}
