################################
###  Security Group
################################

resource "aws_security_group" "client-vpn-access" {
  name   = "terraform-shared-client-vpn-access"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################################
###  Cloudwatch Log Group
################################

resource "aws_cloudwatch_log_group" "cloudwatch-log-group" {
  name              = "client-vpn-endpoint-${var.domain}"
  retention_in_days = "30"

  tags = {
    Name        = var.domain
    Environment = "global"
    Terraform   = "true"
  }
}

################################
### Upload certs to acm
################################
resource "aws_acm_certificate" "vpn_client_root" {
  private_key       = file("certs/ca.key")
  certificate_body  = file("certs/ca.crt")
  certificate_chain = file("certs/ca.crt")
}
# resource "aws_acm_certificate" "vpn_server_root" {
#   private_key = file("certs/ca.key")
#   certificate_body = file("certs/ca.crt")
#   certificate_chain = file("certs/ca.crt")
# }

################################
###  Client VPN Endpoint
################################

resource "aws_iam_saml_provider" "saml_provider" {
  name                   = "terraform-saml-provider"
  saml_metadata_document = file("certs/saml-metadata.xml")
}

resource "aws_ec2_client_vpn_endpoint" "client-vpn-endpoint" {
  description            = "terraform-client-vpn-endpoint"
  server_certificate_arn = aws_acm_certificate.vpn_server_root.arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  dns_servers            = var.dns_servers

  authentication_options {
    type              = "federated-authentication"
    saml_provider_arn = aws_iam_saml_provider.saml_provider.arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.cloudwatch-log-group.name
  }

  tags = {
    Name        = var.domain
    Environment = "global"
    Terraform   = "true"
  }
}

resource "aws_ec2_client_vpn_network_association" "client-vpn-network-association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  subnet_id              = aws_subnet.main.id
  security_groups        = [aws_security_group.client-vpn-access.id]
}

resource "aws_ec2_client_vpn_route" "client-vpn-route" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_subnet.main.id
  description            = "Internet Access"

  depends_on = [
    aws_ec2_client_vpn_endpoint.client-vpn-endpoint,
    aws_ec2_client_vpn_network_association.client-vpn-network-association
  ]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  target_network_cidr    = aws_vpc.main.cidr_block
  authorize_all_groups   = true
}
