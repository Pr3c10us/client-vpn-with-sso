variable "region" {
  default = "us-east-1"
}

variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation being /22 or greater, from which to assign client IP addresses"
  default     = "18.0.0.0/22"
}

variable "domain" {
  default = "aws-vpn.reflektion.com"
}

variable "split_tunnel" {
  default = "false"
}

variable "dns_servers" {
  type = list
  default = [
    "8.8.8.8",
    "1.1.1.1"
  ]
}

