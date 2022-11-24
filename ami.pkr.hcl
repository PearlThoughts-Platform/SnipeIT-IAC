packer {
    required_plugins {
      amazon = {
        version = ">= 0.0.2"
        source  = "github.com/hashicorp/amazon"
      }
    }
  }

  variable "build_number" {}
  variable "commit_sha" {}
  #variable "aws-access-key-id" {}
  #variable "aws-secret-access-key" {}

  source "amazon-ebs" "linux" {
    # AMI Settings
    ami_name                      = "SnipeIt_goldenAMI_${var.build_number}"
    instance_type                 = "t2.micro"
    source_ami                    = "ami-07651f0c4c315a529"
    ssh_username                  = "ubuntu"
    associate_public_ip_address   = false
    ami_virtualization_type       = "hvm"
    #role_arn                     = "arn:aws:iam::629974703195:user/terraform-user"           
    #access_key                    = "${var.aws-access-key-id}"
    #region                       = "ap-southeast-2"
    #secret_key                    = "${var.aws-secret-access-key}"
        #role_arn     = "arn:aws:iam::629974703195:user/terraform-user"  #new ami id
        #session_name = "SESSION_NAME"
        #external_id  = "EXTERNAL_ID"
    #}
    
    tags = {
      type = "base_image"
      commit_id = "${var.commit_sha}"
      build_number = "${var.build_number}"
      server = "api"

    }
   
      
    
    launch_block_device_mappings {
      device_name = "/dev/sda1"
      volume_size = 8
      volume_type = "gp2"
      delete_on_termination = true
      encrypted = false
    }
  
    # Profile Settings
    region                        = "ap-southeast-2"
    ami_regions                   = ["ap-southeast-2"]
  }
  
  build {
    sources = [
      "source.amazon-ebs.linux"
    ]
    provisioner "ansible" {
      playbook_file = "Ansible/main.yml"
      user = "ubuntu"
    }
  }
