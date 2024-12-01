resource "aws_iam_role" "my-role-node" {
  name = "my-role-node"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "my-role-node-sts"
  }
}

resource "aws_iam_role_policy_attachment" "my-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.my-role-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" #Policy padrão da aws
}

resource "aws_iam_role_policy_attachment" "my-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.my-role-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" #Policy padrão da aws: permite comunicacao entre os nodes
}

resource "aws_iam_role_policy_attachment" "my-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.my-role-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" #Policy padrão da aws
}

resource "aws_eks_node_group" "my-eks-node-group-1" {
  cluster_name    = aws_eks_cluster.my-ec.name
  node_group_name = "my-eks-node-group-1"
  node_role_arn   = aws_iam_role.my-role-node.arn
  subnet_ids      = aws_subnet.my-subnet[*].id

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  # update_config {
  #   max_unavailable = 1
  # }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.my-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.my-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.my-AmazonEC2ContainerRegistryReadOnly,
  ]
}