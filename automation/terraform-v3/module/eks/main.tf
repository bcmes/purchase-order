resource "aws_security_group" "my-sg" {
  vpc_id      = var.my_vpc_id
  egress { #o vpc pode acessar qualquer site, regras de saída.
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name = "my-security-group"
  }
}

resource "aws_iam_role" "my-role-cluster" {
  name = "my-role-eks-sts"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "my-role-sts"
  }
}

resource "aws_iam_role_policy_attachment" "my-rpa-AmazonEKSVPCResourceController" {
  role       = aws_iam_role.my-role-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController" #Policy padrão da aws
}

resource "aws_iam_role_policy_attachment" "my-rpa-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.my-role-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" #Policy padrão da aws
}

resource "aws_cloudwatch_log_group" "my-clg" {
  name = "/aws/eks/my-cloudwatch-log-group/cluster"
  retention_in_days = 3
}

resource "aws_eks_cluster" "my-ec" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.my-role-cluster.arn #aplicando uma role ao recurso
  enabled_cluster_log_types = ["api","audit"]

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.my-sg.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.my-rpa-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.my-rpa-AmazonEKSClusterPolicy,
    aws_cloudwatch_log_group.my-clg,
  ]
}

# MEUS NODES

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
  subnet_ids      = var.subnet_ids
  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 2 #neste node-group sempre terei 2 maquinas de pé
    max_size     = 4 #se o bixo pegar, sobe pra 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.my-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.my-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.my-AmazonEC2ContainerRegistryReadOnly,
  ]
}