resource "aws_eks_node_group" "cmp_primary_node_group" {
  cluster_name    = aws_eks_cluster.cmp-eks-dev.name
  node_group_name = var.cmp_primary_node_group
  node_role_arn   = aws_iam_role.node_role_dev.arn
  subnet_ids      = ["${var.private_subnet_1}", "${var.private_subnet_2}"] 
  instance_types  = [var.cmp_primary_instance_type]
  disk_size      = var.primary_nodes_disk_size
  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = [aws_security_group.cmp-eks-dev.id]
  }
  scaling_config {
    desired_size = var.desired-capacity-primary
    max_size     = var.max-size-primary
    min_size     = var.min-size-primary
  }

  depends_on = [
    aws_iam_role_policy_attachment.cmp-eks-workers-dev-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cmp-eks-workers-dev-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cmp-eks-workers-dev-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = var.cluster_name
  }  
}


#resource "aws_eks_node_group" "cmp_secondary_node_group" {
#  cluster_name    = aws_eks_cluster.cmp-eks-dev.name
#  node_group_name = var.cmp_secondary_node_group
#  node_role_arn   = aws_iam_role.node_role_dev.arn
#  subnet_ids      = ["${var.private_subnet_1}", "${var.private_subnet_2}"] 
#  instance_types  = var.cmp_secondary_instance_type
#  disk_size       = var.secondary_nodes_disk_size
#  remote_access {
#    ec2_ssh_key               = var.ec2_ssh_key
#    source_security_group_ids = [aws_security_group.cmp-eks-dev.id]
#  }
#  scaling_config {
#    desired_size = var.desired-capacity-secondary
#    max_size     = var.max-size-secondary
#    min_size     = var.min-size-secondary
#  }


#  depends_on = [
#    aws_iam_role_policy_attachment.cmp-eks-workers-dev-AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.cmp-eks-workers-dev-AmazonEKS_CNI_Policy,
#    aws_iam_role_policy_attachment.cmp-eks-workers-dev-AmazonEC2ContainerRegistryReadOnly,
#  ]

#  tags = {
#    Name = var.cluster_name
#  }  
#}

