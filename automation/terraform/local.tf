# terraform {
#   required_providers {
#     local = {
#       source  = "hashicorp/local"
#       version = "2.5.1"
#     }
#   }
# }
resource "local_file" "foo" {
  content  = var.conteudo #Se existir o valor vem do terraform.rfvars, senao vem do default da variable, senao é informado no momento do apply
  filename = "my-file-x.txt"
}


variable "conteudo" {
  type = string
  default = "Valor default"
}

# posso obter valores que sao gerados somente depois do apply
output "id-do-arquivo" {
  value = resource.local_file.foo.id
}

#obtem informacoes de recursos já criados
data "local_file" "my-data-source" {
  filename = "my-file-x.txt"
}

#imprimindo valores obtidos do data-source
output "data-source-result" {
  value = data.local_file.my-data-source.content
}