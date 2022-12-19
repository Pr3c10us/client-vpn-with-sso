resource "aws_vpc" "main" {
  cidr_block = "172.20.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  #tags = local.global_tags
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # tags = local.global_tags
}
resource "aws_subnet" "main" {

  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = false

  cidr_block = aws_vpc.main.cidr_block
}
