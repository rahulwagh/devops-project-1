module "security_group" {
  source      = "../1-step/security-groups"
  ec2_sg_name = "SG for EC2 to enable SSH(22) and HTTP(80)"
  vpc_id      = module.networking.dev_proj_1_vpc_id
}
