variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "availability_zones" {
  type = list(string)
  default = [
    "ap-south-1a", "ap-south-1b", "ap-south-1c"
  ]
}

variable "project_name" {
  default = "SMW"
}

variable "Environment" {
  default = "Dev"
}

variable "domain_name" {
  type    = string
  default = "smwiac.plts-dev.com"

}


#EC2

variable "api_instance_type" {
  type    = string
  default = "t2.micro"
}



variable "api_instance_storage_size" {
  default = 16
}


variable "key_name" {
  type    = string
  default = "api"
}

#RDS

variable "rds_snapshot_arn" {
  default = "arn:aws:rds:us-east-1:580880756845:cluster-snapshot:dev-sandboxsharing-customkms"

}

variable "rds_instance_class" {
  default = "db.t3.small"
}

variable "common_name" {
  default = "api"
}

#SecretManager

variable "secret_arn" {
  default = "arn:aws:secretsmanager:us-east-1:078588486142:secret:api1_env_vars-S8VPgP"
}





