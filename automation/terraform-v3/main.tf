module "my-module-vpc" {
  source = "./module/vpc" #tá fazendo o import de tudo que está no caminho informado
  prefix = var.prefix #prefix é a variavel solicitada no modulo "./module/vpc", já var.prefix é o valor passado, que acaba vindo do terraform.tfvars
}

module "my-module-eks" {
  source = "./module/eks"
  my_vpc_id = module.my-module-vpc.vpc_id #O valor vem do output do modulo "my-module-vpc" acima
  subnet_ids = module.my-module-vpc.my_subnets_ids
}
