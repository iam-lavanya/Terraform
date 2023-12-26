provider "aws" {
  region = "var.region_name"  # Update with your preferred region
}

resource "aws_eks_cluster" "EKS_Cluster" {
  name     = "EKS_Cluster"
  role_arn = aws_iam_role.IAM_EKS.arn

  vpc_config {
    subnet_ids = ["subnet-08d1bf0017f76d884", "subnet-0cdf71ab11b40e8cb"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.Policy-AmazonEKSClusterPolicy
  ]
}

output "endpoint" {
  value = aws_eks_cluster.EKS_Cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.EKS_Cluster.certificate_authority[0].data
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "IAM_EKS" {
  name               = "eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.IAM_EKS.name
}
