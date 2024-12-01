output "endpoint" {
  value = aws_eks_cluster.my-ec.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-ec.certificate_authority[0].data
}