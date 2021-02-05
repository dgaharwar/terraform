
resource "aws_secretsmanager_secret" "new_secret_object" {
  count = "${var.secret_arn == "" ? 1 : 0}"

  name                = "${var.secret_name}"
  description         = "RDS info"
  kms_key_id          = "${var.secret_cmk_id}" 
    
  tags = {
    Author = "Effectual Terraform script"
    Date = "${timestamp()}"
  } 

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "secret-policy",
    "Statement": [
        {
            "Sid": "AllowUseOfTheKey",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.cicd_role_arn}"
            },
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "*",
            "Condition": { "ForAnyValue:StringLike": { "secretsmanager:SecretId": "*${var.secret_name}*" } }
        }
    ]
}
EOF
}

resource "aws_secretsmanager_secret_version" "values" {
  count = "${var.secret_arn == "" ? 1 : 0}"

  secret_id     = "${aws_secretsmanager_secret.new_secret_object[0].id}" 

   secret_string = <<EOF
    {
      "DBName"     : "${var.secret_value_dbname}",
      "DBEndPoint" : "${var.secret_value_dbendpoint}",
      "DBARN"      : "${var.secret_value_dbarn}",
      "Username"   : "${var.secret_value_dbusername}",
      "Password"   : "${var.secret_value_dbpassword}", 
      "Port"       : "${var.db_port}",
      "Account"    : "${var.account_name}",
      "Engine"     : "${var.engine_name}"
    }
EOF
  #The code below was replaced by the secret_string above to make the script work with Morpheus.
  #"${jsonencode(DBName = ${var.secret_value_dbname}, DBEndPoint = ${var.secret_value_dbendpoint}, DBARN = ${var.secret_value_dbarn}, Username = ${var.secret_value_dbusername}, Password = ${var.secret_value_dbpassword})}"  
}

resource "aws_secretsmanager_secret_version" "values_for_existing_secret" {
  count = "${var.secret_arn != "" ? 1 : 0}"

  secret_id     = "${var.secret_arn}" 
   secret_string = <<EOF
    {
      "DBName"     : "${var.secret_value_dbname}",
      "DBEndPoint" : "${var.secret_value_dbendpoint}",
      "DBARN"      : "${var.secret_value_dbarn}",
      "Username"   : "${var.secret_value_dbusername}",
      "Password"   : "${var.secret_value_dbpassword}", 
      "Port"       : "${var.db_port}",
      "Account"    : "${var.account_name}",
      "Engine"     : "${var.engine_name}"
    }
EOF
}


