# AWS RDS Terraform module

Terraform module which creates RDS resources in DMC3-Test (by default) on AWS.

The following resources are created:
* [Policy document](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html)
* [Policy attachment](https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html)
* [IAM role](https://www.terraform.io/docs/providers/aws/r/iam_role.html)
* [DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
* [Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [DB Parameter Group](https://www.terraform.io/docs/providers/aws/r/db_parameter_group.html)
* [DB Option Group](https://www.terraform.io/docs/providers/aws/r/db_option_group.html)
* [DB Instance](https://www.terraform.io/docs/providers/aws/r/db_instance.html)

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
| account\_name | Name of client's account | `string` | `RFS` | yes |
| environment | Environment in which the RDS is created | `string` | n/a | no |
| region | Region where the resources will be created | `string` | `us-gov-east-1` | yes |

### For the DBInstance

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db\_name | Name of the new database | `string` | `""` | yes |
| db\_port | The port on which the DB accepts connections | `string` | `1521` | yes |
| vpc\_id | ID of the VPC where the DB will be created | `string` | `""` | yes | 
| instance\_class | Type/Size of instance | `string` | `db.m5.large` | yes | 
| multi\_az | Indicates if the DB will be in multiple AZ or not | `bool` | `true` | yes | 
| iops | IOPS | `string` | `4000` | yes | 
| storage\_type | Type/Size of instance | `string` | `io1` | yes | 
| allocated\_storage | The allocated storage in gigabytes | `number` | `500` | yes | 
| max\_allocated\_storage | Specifies the value for Storage Autoscaling | `number` | `1000` | yes | 
| engine\_version | The engine version to use | `string` | `12` | yes | 
| character\_set\_name | The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information | `string` | `""` | no | 
| backup\_window | Backup window (times) | `string` | `20:00-21:00` | yes |
| backup\_retention\_period | Number of days to keep a backup | `number` | `35` | yes |
| maintenance\_window | Day(s) where maintenance will take place | `string` | `Fri:22:00-Fri:23:00` | yes |
| timeouts | Applies to `aws_db_instance` in particular to permit resource management times | `map(string)` | create = "40m", update = "80m", delete "40m"` | yes |

### For the DBParameterGroup

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| family | The family of the DB parameter group | `string` | `sqlserver-se-12.0` | yes |
| pg\_description | Description for the Parameter Group | `string` | `Database parameter group for <db_name>` | yes |


### For the DBOptionGroup

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| og\_description | The description of the option group | `string` | `""` | no |
| engine\_name | Specifies the name of the engine that this option group should be associated with | `string` | `sqlserver-se` | yes |
| options | A list of Options to apply | `any` | `""` | no |
| db\_username | Username | `string` | `""` | yes |
| major\_engine\_version | Specifies the major version of the engine that this option group should be associated with | `string` | `12` | yes |
| option\_group\_timeouts | Define maximum timeout for deletion of `aws_db_option_group` resource | `map(string)` | 15m | yes |

## Outputs

| Name | Description |
|------|-------------|
| new\_db\_instance\_name | The name of the RDS instance |
| new\_db\_instance\_arn | The ARN of the RDS instance |
| new\_db\_instance\_endpoint | The Endpoint of the RDS instance |
| new\_db\_instance\_password | The password of the user that has access to the DB |

### Terraform Command Manual Deployment
```terraform
terraform apply -var db_name="<NEW_DB_NAME>" 
```

```terraform
terraform apply -var db_name="<NEW_DB_NAME>" -var vpc_id="vpc-0a4c258982b48c5f0"
```