/*output "remote_state_s3_bucket" {
  value = module.s3.remote_state_s3_bucket_name
}*/

output "dev_proj_1_vpc_id" {
  value = module.networking.dev_proj_1_vpc_id
}

output "ec2_ssh_string" {
  value = module.ec2.ssh_connection_string_for_ec2
}