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
    ami_name                      = "snipeitdev_mygoldenAMI_${var.build_number}"
    instance_type                 = "t2.micro"
    source_ami                    = "ami-062df10d14676e201"
    ssh_username                  = "ubuntu"
    associate_public_ip_address   = false
    ami_virtualization_type       = "hvm"
    #role_arn                     = "arn:aws:iam::763342761933:role/AWS_SSM_ROLE"           
    #access_key                    = "${var.aws-access-key-id}"
    #region                       = "ap-south-1"
    #secret_key                    = "${var.aws-secret-access-key}"
        #role_arn     = "arn:aws:iam::763342761933:role/AWS_SSM_ROLE"
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
    region                        = "ap-south-1"
    ami_regions                   = ["ap-south-1"]
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
