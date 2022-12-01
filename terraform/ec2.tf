#AMI DATA

data "aws_ami" "api" {
  most_recent = true
  owners      = ["self"]  #self hosted

  filter {
    name   = "tag:server"
    values = ["api"]
  }
  filter {
    name   = "tag:type"
    values = ["base_image"]
  }

}


output "ami_id" {
  value = data.aws_ami.api.image_id
}




#IAM ROLE

resource "aws_iam_role" "SSMRole" {
  name               = "SSMRole"
  description        = "Role created to allow SSM"
  assume_role_policy = file("ssm_role.json")
}

resource "aws_iam_role_policy_attachment" "SSMPolicy" {
  role       = aws_iam_role.SSMRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "api_profile" {
  name = "api_ec2_profile"
  role = aws_iam_role.SSMRole.name
}

#EC2

resource "aws_instance" "api" {
  ami                    = data.aws_ami.api.image_id
  iam_instance_profile   = aws_iam_instance_profile.api_profile.name
  instance_type          = var.api_instance_type
  #vpc_security_group_ids = [aws_security_group.webserver.id]

  user_data = <<EOF
  #!/bin/bash
  sudo certbot --apache --agree-tos  -m smw@test.com -d smw.com --non-interactive
  sudo service apache2 restart
  EOF

  root_block_device {
    volume_size = var.api_instance_storage_size
  }


  tags = {
    Name = "${local.common_resource_name}-api"
  }


}


#Elastic IP

resource "aws_eip_association" "api" {
  instance_id = aws_instance.api.id
  public_ip   = aws_eip.api.public_ip
}
