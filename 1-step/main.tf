/*module "s3" {
  source      = "./s3"
  bucket_name = var.bucket_name
  name        = var.name
  environment = var.bucket_name
}*/

module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "security_group" {
  source      = "./security-groups"
  ec2_sg_name = "SG for EC2 to enable SSH(22) and HTTP(80)"
  vpc_id      = module.networking.dev_proj_1_vpc_id
}

module "ec2" {
  source                   = "./ec2"
  ami_id                   = var.ec2_ami_id
  instance_type            = "t2.micro"
  tag_name                 = "Ubuntu Linux EC2"
  public_key               = var.public_key
  subnet_id                = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_enable_ssh_https      = module.security_group.sg_ec2_sg_ssh_http_id
  enable_public_ip_address = true
  user_data_install_apache = templatefile("./template/ec2_install_apache.sh", {})
}

module "lb_target_group" {
  source                   = "./load-balancer-target-group"
  lb_target_group_name     = "dev-proj-1-lb-target-group"
  lb_target_group_port     = 80
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.dev_proj_1_vpc_id
  ec2_instance_id          = module.ec2.dev_proj_1_ec2_instance_id
}

module "alb" {
  source                   = "./load-balancer"
  lb_name                  = "dev-proj-1-alb"
  is_external              = false
  lb_type                  = "application"
  sg_enable_ssh_https      = module.security_group.sg_ec2_sg_ssh_http_id
  subnet_ids               = tolist(module.networking.dev_proj_1_public_subnets)
  tag_name                 = "dev-proj-1-alb"
  lb_target_group_arn      = module.lb_target_group.dev_proj_1_lb_target_group_arn
  ec2_instance_id          = module.ec2.dev_proj_1_ec2_instance_id
  lb_listner_port          = 80
  lb_listner_protocol      = "HTTP"
  lb_listner_default_action = "forward"
}