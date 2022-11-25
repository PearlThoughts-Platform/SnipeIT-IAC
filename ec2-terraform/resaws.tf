resource "aws_key_pair" "deployer" {
  key_name   = "ec2-deployer-key-pair"
  public_key = "your public_key look like that ssh-rsa AAAAB3N…”
}