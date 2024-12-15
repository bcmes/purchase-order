resource "aws_security_group" "my-sg" {
  vpc_id      = aws_vpc.my-vpc.id
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
    subnet_ids = aws_subnet.my-subnet[*].id
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
