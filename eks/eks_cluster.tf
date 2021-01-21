resource "aws_eks_cluster" "cmp-eks-dev" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster_role_dev.arn

  vpc_config {
    security_group_ids = [aws_security_group.cmp-eks-dev.id]
    subnet_ids         = ["${var.public_subnet_1}", "${var.public_subnet_2}", "${var.private_subnet_1}", "${var.private_subnet_2}"] 
  }

  depends_on = [
    aws_iam_role_policy_attachment.cmp-eks-dev-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cmp-eks-dev-AmazonEKSServicePolicy,
  ]
}
output "endpoint" {
  value = aws_eks_cluster.cmp-eks-dev.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = aws_security_group.cmp-eks-dev.id
}


output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.cluster_name
}

#resource "local_file" "clustername" {
#  content         = var.cluster_name
#  filename        = "/tmp/cluster_name"
#  file_permission = "0644"
#}