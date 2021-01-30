variable "public_subnet_ids" {
  type        = list(string)
  description = "Public Subnet ids"
}

variable "db_bastion_sg_id" {
}

variable "env" {
}

variable "bastion_ami_id" {
  default = "ami-098828924dc89ea4a" # Amazon Linux 2 AMI (HVM), SSD Volume Type
}

variable "bastion_host_pubkey" {

}
