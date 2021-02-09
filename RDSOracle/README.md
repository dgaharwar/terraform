# AWS RDS Terraform module
TESTING FOR GIT PULL

Terraform module which creates RDS (Oracle) resources in a given AWS account, and stores the ARN, endpoint, username and password in the SOC Secret's manager.

Two modules are called:
* RDS
* SecretsManager

The following resources are created:
* RDS 
  - [Policy document](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html)
  - [Policy attachment](https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html)
  - [IAM role](https://www.terraform.io/docs/providers/aws/r/iam_role.html)
  - [DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
  - [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)
  - [DB Parameter Group](https://www.terraform.io/docs/providers/aws/r/db_parameter_group.html)
  - [DB Option Group](https://www.terraform.io/docs/providers/aws/r/db_option_group.html)
  - [DB Instance](https://www.terraform.io/docs/providers/aws/r/db_instance.html)
* SecretsManager   
  - [Secret](https://www.terraform.io/docs/providers/aws/r/secretsmanager_secret.html)
  - [Secret values](hthttps://www.terraform.io/docs/providers/aws/r/secretsmanager_secret_version.html)


## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.49 |

## Inputs

### Required and Default values

The following are required inputs:
* db\_name: The name of the new DB
* db\_username: The username for the new DB
* vpc\_id: The ID of the VPC where the new DB will be created
* secret\_name: The name of the secret in SOC that will store the outputs

The rest are optional with default values.

Important optional inputs (with their default values in parenthesis):
* account\_name (DMC3Test)
* region (us-gov-east-1)
* port (1521)
* instance\_class (db.m5.2xlarge)
* allocated\_storage (500)
* max_allocated\_storage (1000)
* backup\_retention\_period (35)
* family (oracle-ee-12.1)
* engine\_name (oracle-ee)
* major\_engine\_version (12.1)


### Generic variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client | Name of the client | `string` | `GinnieMae` | yes |
| account\_name | Name of client's account | `string` | `DMC3Test` | yes |
| environment | Environment in which the RDS is created | `string` | n/a | no |
| region | Region where the resources will be created | `string` | `us-gov-east-1` | yes |

### For the DBInstance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db\_name | Name of the new database | `string` | `""` | yes |
| db\_port | The port on which the DB accepts connections | `string` | `1521` | yes |
| vpc\_id | ID of the VPC where the DB will be created | `string` | `""` | yes | 
| instance\_class | Type/Size of instance | `string` | `db.m5.2xlarge` | yes | 
| multi\_az | Indicates if the DB will be in multiple AZ or not | `bool` | `true` | yes | 
| iops | IOPS | `string` | `4000` | yes | 
| storage\_type | Type/Size of instance | `string` | `io1` | yes | 
| allocated\_storage | The allocated storage in gigabytes | `number` | `500` | yes | 
| max\_allocated\_storage | Specifies the value for Storage Autoscaling | `number` | `1000` | yes | 
| engine\_version | The engine version to use | `string` | `12.1` | yes | 
| character\_set\_name | The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information | `string` | `""` | no | 
| backup\_window | Backup window (times) | `string` | `20:00-21:00` | yes |
| backup\_retention\_period | Number of days to keep a backup | `number` | `35` | yes |
| maintenance\_window | Day(s) where maintenance will take place | `string` | `Fri:22:00-Fri:23:00` | yes |
| timeouts | Applies to `aws_db_instance` in particular to permit resource management times | `map(string)` | create = "40m", update = "80m", delete "40m"` | yes |

### For the DBParameterGroup

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| family | The family of the DB parameter group | `string` | `oracle-ee-12.1` | yes |
| open\_cursors | Value for the parameter open_cursors | `number` | `4000` | yes |
| undo\_retention | Value for the parameter undo_retention | `number` | `900` | yes |
| query\_rewrite\_integrity | Value for the parameter query_rewrite_integrity | `string` | `ENFORCED` | yes |
| enable\_goldengate\_replication | Value for the parameter enable_goldengate_replication | `bool` | `false` | yes |
| session\_cached\_cursors | Value for the parameter session_cached_cursors | `number` | `50` | yes |
| db\_files | Value for the parameter db_files | `number` | `200` | yes |

### For the DBOptionGroup

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| engine\_name | Specifies the name of the engine that this option group should be associated with | `string` | `oracle-ee` | yes |
| major\_engine\_version | Specifies the major version of the engine that this option group should be associated with | `string` | `12.1` | yes |
| enable\_s3\_integration | Indicates if S3 integration should be turned on or not | `boolean` | true | yes |

### For the Secret
These values are not required as inputs. Terraform autopopulates these variables using the outputs from the RDS module.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| secret\_arn | The ARN of an existing secret, if the values should be updated. Leave blank if a new Secret needs to be created | `string` | `""` | no |
| secret\_value\_dbendpoint | String to connect to the DB | `string` | `""` | yes |
| secret\_value\_dbarn | ARN of the DB | `string` | `""` | yes |
| secret\_value\_dbpassword | Password for the master user | `string` | `""` | yes |
| secret\_cmk\_id | The ID of the Customer Managed Key used to encrypt the Secret | `string` | `b212caf4-3256-4e98-9851-ca49fdfb00c1` | yes |
| cicd\_role\_arn | The ARN of the CICD Role that will be given access to the Secret | `string` | not shown here | yes |

## Outputs
TBD

### Terraform Command Manual Deployment
```terraform
terraform apply -var db_name="<NEW_DB_NAME>" -var vpc_id="<VPC_ID>"
```

```terraform
terraform apply -var db_name="<NEW_DB_NAME>" -var vpc_id="<VPC_ID>" -var engine_name="<ENGINE_NAME>" -var region="us-gov-west-1"
```

Complex example:

```terraform
terraform apply -var db_name="gnmdb1" -var vpc_id="vpc-01234567" -var family="oracle-ee-12.1" -var engine_name="oracle-ee" --var db_port="1521" -var allocated_storage="250"
```
