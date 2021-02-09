module "mod_rds" {
    source      = "./modules/RDS/"

    #inputs:
    access_key              = var.access_key
    secret_key              = var.secret_key
    
    client                  = var.client
    environment             = var.environment
    region                  = var.region
    vpc_subnet_az1          = var.vpc_subnet_az1
    vpc_subnet_az2          = var.vpc_subnet_az2
    family                  = var.family
    engine_name             = var.engine_name
    major_engine_version    = var.major_engine_version
    options                 = var.options
    db_name                 = lower(var.db_name)
    db_port                 = var.db_port
    allocated_storage       = var.allocated_storage
    max_allocated_storage   = var.max_allocated_storage
    character_set_name      = var.character_set_name
}

module "mod_secretsmanager" {
    source = "./modules/SecretsManager/"

    #inputs:
    soc_access_key          = var.soc_access_key
    soc_secret_key          = var.soc_secret_key

    secret_name             = "${var.client}/${var.account_name}/RDS/${var.db_name}"  #Will result in GinnieMae/DMC3Test/RDS/<dbname> 
    secret_arn              = var.secret_arn
    secret_value_dbname     = lower(var.db_name)
    secret_value_dbendpoint = "${module.mod_rds.new_db_instance_endpoint}"
    secret_value_dbarn      = "${module.mod_rds.new_db_instance_arn}"
    secret_value_dbusername = "${module.mod_rds.new_db_instance_username}"
    secret_value_dbpassword = "${module.mod_rds.new_db_instance_password}"
    db_port                 = "${var.db_port}"
    account_name            = "${var.account_name}"
    engine_name             = "${var.engine_name}"
}
