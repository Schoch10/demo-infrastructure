variable "region" {}

variable "target" {}

variable "stack" {}

variable "azs" {
  type = "list"
}

variable "pub_sub_cidr" {
  type = "list"
}

variable "vpc_id" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "public" {
  count                   = "${length(var.pub_sub_cidr)}"
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(var.pub_sub_cidr, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.target}-${var.stack}-pub-${count.index}"
    Stack       = "${var.stack}"
    Target      = "${var.target}"
    Owner       = "BruceCutler"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-igw"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
    Owner       = "BruceCutler"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.target}-${var.stack}-pub-routetable"
    Environment = "${var.target}-${var.stack}"
    Target      = "${var.target}"
    Stack       = "${var.stack}"
    Owner       = "BruceCutler"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.pub_sub_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "igw_route" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}


output "pub_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "aws_rtb_id" {
  value = "${aws_route_table.public.id}"
}
