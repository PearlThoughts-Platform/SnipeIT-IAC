# resource "aws_s3_bucket" "SMWS3" {
#   bucket_prefix = "${local.common_resource_name}-"
# }

# resource "aws_s3_bucket_policy" "SMWS3" {
#   bucket = aws_s3_bucket.SMWS3.id

#   policy = <<POLICY
# {
#     "Version": "2008-10-17",
#     "Id": "PolicyForCloudFrontPrivateContent",
#     "Statement": [
#         {
#             "Sid": "1",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::${aws_s3_bucket.SMWS3.bucket}/*"
#         }
#     ]
# }
# POLICY
# }

# # module "s3" {
# #   source            = "digitickets/cli/aws"
# #   role_session_name = "S3sync"
# #   aws_cli_commands  = ["s3", "sync", "s3://${var.prod_s3_bucket} s3://${aws_s3_bucket.SMWS3.bucket}"]
# # }