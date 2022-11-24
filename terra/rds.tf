# data "aws_secretsmanager_secret" "secrets" {
#   arn = var.secret_arn
# }

# data "aws_secretsmanager_secret_version" "current" {
#   secret_id = data.aws_secretsmanager_secret.secrets.id
# } 
 
#   resource "aws_db_instance" "default" {
#   allocated_storage    = 20
#   max_allocated_storage = 1000
#   identifier = "${local.common_resource_name}-"
#   port                 = 3306
#   engine               = "mysql"
#   engine_version       = "8.0.28"
#   instance_class       = "db.t2.micro"
#   #name                 = "smw-dev"
#   username             = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DB_USERNAME"]
#   password             = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["DB_PASSWORD"]
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
# }