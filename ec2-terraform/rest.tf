resource "aws_instance" "app_server" {
  count                  = 2
  ami                    = "ami-047e03b8591f2d48a"
  instance_type          = "t2.micro"
  key_name               = "ec2-deployer-key-pair"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "First-Ec2-With-Terraform"
  }
  connection {
    type    = "ssh"
    host    = self.public_ip
    user    = "ec2-user"
    timeout = "4m"
  }
}