resource "aws_eks_cluster" "dg-eks-cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.AWSServiceRoleForAmazonEKS.arn

  vpc_config {
    security_group_ids = [aws_security_group.automation.id]
    subnet_ids         = ["${var.labs_app_1a (subnet-964389f2)}", "${var.labs_app_1b (subnet-9b8eddb7)
}", "${var.labs_lb_1a (subnet-c94d87ad)
}", "${var.labs_lb_1b (subnet-b88fdc94)
}"] 
  }

  depends_on = [
    aws_iam_role_policy_attachment.AWSServiceRoleForAmazonEKS-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AWSServiceRoleForAmazonEKS-AmazonEKSServicePolicy,
  ]
}
output "endpoint" {
  value = aws_eks_cluster.AWSServiceRoleForAmazonEKS.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = aws_security_group.automation.id
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
