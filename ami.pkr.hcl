


packer {
    required_plugins {
      amazon = {
        version = ">= 0.0.2"
        source  = "github.com/hashicorp/amazon"
      }
    }
  }

  
  source "amazon-ebs" "ubuntu" {
    # AMI Settings
    ami_name                      = "snipeit-Pearl-AMI-${var.build_number}"
    instance_type                 = "t2.micro"
    region                        = "ap-south-1"
    source_ami                    = "ami-08161112e301e70b4"
    ssh_username                   = "ubuntu"
    associate_public_ip_address   =  false
    ami_virtualization_type       = "hvm"


    #role_arn                     = "arn:aws:iam::416991812294:role/s3jenkins"           
    #access_key                    = "${var.aws-access-key-id}"
    #secret_key                    = "${var.aws-secret-access-key}"
        #role_arn     = "arn:aws:iam::416991812294:role/s3jenkins"
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
    // region                        = "ap-south-1"
    // ami_regions                   = ["ap-south-1"]
  }
  
  build {
    name    = "Let's Snipe IT"
    sources = [ 
      "source.amazon-ebs.ubuntu"
    ]
  
    provisioner "ansible" {
      playbook_file = "Ansible/main-ansible.yaml"
      user = "ubuntu"
    }
  }


// Variables
variable "build_number" {}

variable "commit_sha" {}

// variable "aws_region" { 

//     type = string
//     default="ap-south-1"

// }


  #variable "aws-access-key-id" {}
  #variable "aws-secret-access-key" {}