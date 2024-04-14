module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"
  subnet_id =   module.vpc.subnet_id
}

module "TG" {
  source        = "./TG"
  vpc_id        = module.vpc.vpc_id
  instance_id   = module.ec2.instance_id
  sg_id         = module.vpc.sg_id
  subnet_id     = module.vpc.pub_subnet_id
  subnet_id_2   = module.vpc.pub_subnet_id_2
}