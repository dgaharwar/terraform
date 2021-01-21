resource "aws_iam_role_policy_attachment" "cmp-eks-dev-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role_dev.name
}

resource "aws_iam_role_policy_attachment" "cmp-eks-dev-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_role_dev.name
}
resource "aws_iam_role_policy_attachment" "cmp-eks-workers-dev-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role_dev.name
}

resource "aws_iam_role_policy_attachment" "cmp-eks-workers-dev-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role_dev.name
}

resource "aws_iam_role_policy_attachment" "cmp-eks-workers-dev-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role_dev.name
}
