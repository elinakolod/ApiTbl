resource "aws_key_pair" "this" {
  key_name   = "${local.project_name-environment}_keypair"
  public_key = file("${path.root}/ssh_keys/${local.project_name-environment}.pub")
}
