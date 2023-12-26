resource "aws_eks_node_group" "Node_grp" {
  cluster_name    = aws_eks_cluster.EKS_Cluster.name
  node_group_name = "Node_grp"
  node_role_arn   = aws_iam_role.Node_grp_role.arn
  subnet_ids      = ["subnet-08d1bf0017f76d884", "subnet-0cdf71ab11b40e8cb"]
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.Policy-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Policy-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.Policy-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "Node_grp_role" {
  name = "Node_grp_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "Policy-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.Node_grp_role.name
}

resource "aws_iam_role_policy_attachment" "Policy-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.Node_grp_role.name
}

resource "aws_iam_role_policy_attachment" "Policy-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.Node_grp_role.name
}