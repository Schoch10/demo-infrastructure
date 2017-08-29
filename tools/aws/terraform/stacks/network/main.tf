terraform {
  backend "s3" {}
}

variable "geo" {}

variable "region" {}

variable "target" {}

variable "stack" {}

variable "vpc_cidr_block" {}

variable "azs" {
  type = "list"
}

variable "pub_sub_cidr" {
  type = "list"
}

variable "priv_sub_cidr" {
  type = "list"
}

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source          = "../../modules/network"
  region          = "${var.region}"
  azs             = "${var.azs}"
  target          = "${var.target}"
  stack           = "${var.stack}"
  cidr_block      = "${var.vpc_cidr_block}"
  pub_sub_cidr    = "${var.pub_sub_cidr}"
  priv_sub_cidr   = "${var.priv_sub_cidr}"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "pub_subnet_ids" {
  value = "${module.network.pub_subnet_ids}"
}

output "igw_id" {
  value = "${module.network.igw_id}"
}

output "aws_rtb_id" {
  value = "${module.network.aws_rtb_id}"
}

output "priv_subnet_ids" {
  value = "${module.network.priv_subnet_ids}"
}

output "nat_gateway_id" {
  value = "${module.network.nat_gateway_id}"
}

output "nat_gateway_ip" {
  value = "${module.network.nat_gateway_ip}"
}

output "nat_gateway_cidr" {
  value = "${module.network.nat_gateway_cidr}"
}

output "priv_route_table_id" {
  value = "${module.network.route_table_id}"
}