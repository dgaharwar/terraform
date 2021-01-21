resource "aws_security_group" "cmp-eks-dev" {
  name        = "${var.cluster_name}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.cluster_name}-sg"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpn_cidrs]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_anywhere]
  }
}


