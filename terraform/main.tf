#
# Terraform to deploy EC2.
#

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  # Configuration options 
  region     = "ap-south-1"
  access_key = "secrets.AWS_ACCESS_KEY_ID"
  secret_key = "secrets.AWS_SECRET_ACCESS_KEY"
}

#terraform init -backend-config="access_key=AKIAVQAUTHJP5DCWYAU4" -backend-config="secret_key=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"
# Access-key-ID=AKIAVQAUTHJP5DCWYAU4
# Secret-access-key=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



# curl --location --request POST 'http://api.reworking-internal.com/employer/register' \
# --header 'Accept: application/json' \
# --header 'Authorization: Bearer null' \
# --header 'Cookie: reworking_session=WvxpRlTGCphfW7keb6OPjL7fqjOCZGhNWAXjfeN9' \
# --form 'name="admin"' \
# --form 'email="admin@example.com"' \
# --form 'password="password"' \
# --form 'password_confirmation="password"' \
# --form 'subdomain="employer"' \
# --form 'company="employer inc"'


#AMI DATA

data "aws_ami" "api" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:server"
    values = ["api"]
  }
  filter {
    name   = "tag:type"
    values = ["base_image"]
  }

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

