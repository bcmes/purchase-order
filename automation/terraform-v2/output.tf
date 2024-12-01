output "endpoint" {
  value = aws_eks_cluster.my-ec.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-ec.certificate_authority[0].data
}

locals { #configuracao de conexao com o cluster k8s na aws. Assim posso usar o kubectl do meu terminal comunicando com o k8s na aws
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${aws_eks_cluster.my-ec.certificate_authority[0].data}
    server: ${aws_eks_cluster.my-ec.endpoint}
  name: aws-my-fuck-cluster
contexts:
- context:
    cluster: aws-my-fuck-cluster
    user: "${aws_eks_cluster.my-ec.name}"
  name: "${aws_eks_cluster.my-ec.name}"
current-context: "${aws_eks_cluster.my-ec.name}"
kind: Config
preferences: {}
users:
- name: "${aws_eks_cluster.my-ec.name}"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.my-ec.name}"
KUBECONFIG
}
#para aws, vc deve instalar o "aws-iam-authenticator" para isso funcionar, veja que de "users" para baixo ficou diferente do padrão !
#Para instalar.: https://weaveworks-gitops.awsworkshop.io/60_workshop_6_ml/00_prerequisites.md/50_install_aws_iam_auth.html
#Para atualizar.: https://github.com/awslabs/amazon-eks-ami/issues/966

resource "local_file" "my-kubeconfig" {
  content  = local.kubeconfig
  filename = "kubeconfig"
}

#depois de executar o "terraform apply" e o arquivo "kubeconfig" ser criado, execute.: cp kubeconfig ~/.kube/config
#ou seja, substituimos as configuracoes de conexao do kubernets, para apontar para k8s na aws.
#NA HORA DE COMUNICAR DEU ERRO. NÃO SE USA MAIS aws-iam-authenticator !