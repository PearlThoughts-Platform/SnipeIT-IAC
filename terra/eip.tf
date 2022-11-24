
#Elastic IP

resource "aws_eip_association" "api" {
  instance_id = aws_instance.api.id
  public_ip   = aws_eip.api.public_ip
}

resource "aws_eip" "api" {
  tags = {
    Name   = "${local.common_resource_name}-api"
    Server = "api"
      }
      vpc      = true
}