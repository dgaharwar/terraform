data "morpheus_group" "azuregroup" {
  name = var.azure_group
}

resource "morpheus_api_option_list" "clouds" {
  name               = "Azure clouds"
  description        = "Azure Clouds option list"
  labels             = ["vmcreation", "terraform_managed"]
  visibility         = "private"
  option_list        = "clouds"
  translation_script = <<SCRIPT
  var i=0;
  results = [];
  for(i; i<data.length; i++) {
    results.push({name: data[i].name, value: data[i].id});
  }
  SCRIPT

  request_script = <<SCRIPT
      results.siteId = ${data.morpheus_group.azuregroup.id}
  SCRIPT
}


resource "morpheus_select_list_option_type" "azrPlan" {

  name                     = "Azure Plans"
  description              = "Option to select Azure plan"
  labels                   = ["vmcreation", "terraform_managed","azure"]
  field_name               = "azrPlan"
  export_meta              = false
  show_on_edit             = true
  editable                 = false
  display_value_on_details = true
  field_label              = "azrPlan"
  visibility_field         = "azrCloud"
  dependent_field          = "azrCloud"
  help_block               = "Select sku for VM"

  required                 = true
  option_list_id           = morpheus_api_option_list.azrPlans.id
}
resource "morpheus_api_option_list" "azrPlans" {
  name               = "Azure Plans"
  description        = "Azure Plans option list"
  labels             = ["vmcreation", "terraform_managed","azure"]
  visibility         = "private"
  option_list        = "servicePlans"
  translation_script = <<SCRIPT
  var i=0;
  results = [];
  for(i; i<data.length; i++) {
    results.push({name: data[i].name, value: data[i].id});
  }
  SCRIPT

  request_script = <<SCRIPT
      results.siteId = ${data.morpheus_group.azuregroup.id}
  SCRIPT
}


resource "morpheus_select_list_option_type" "azrCloud" {

  name                     = "Azure cloud"
  description              = "Option to select Morpheus cloud, depending to group"
  labels                   = ["vmcreation", "terraform_managed"]
  field_name               = "azrCloud"
  export_meta              = false
  show_on_edit             = true
  editable                 = false
  display_value_on_details = true
  field_label              = "azrCloud"
  help_block               = "Select Cloudgroup where to install VM"
  required                 = true
  option_list_id           = morpheus_api_option_list.clouds.id
}
resource "morpheus_manual_option_list" "technicalServices" {
  name        = "technicalServices"
  labels      = ["vmcreation", "terraform_managed"]
  description = "List of technical services"
  dataset     = <<POLICY
[{"name":"Active directory service","value":"ADS"},
{"name":"Application server","value":"APP"},
{"name":"Backup","value":"BCK"},
{"name":"Cluster","value":"CLU"},
{"name":"Database servers SQL","value":"SQL"},
{"name":"Database servers Oracle","value":"ORA"},
{"name":"Database servers Hana","value":"HAN"},
{"name":"Database servers Other","value":"DBS"},
{"name":"Dedicated print server","value":"PRT"},
{"name":"Docker","value":"DCK"},
{"name":"File server","value":"FLS"},
{"name":"Firewall","value":"FWS"},
{"name":"Historian node","value":"NOD"},
{"name":"Hypervisor","value":"ESX"},
{"name":"Infra servers","value":"INF"},
{"name":"Jump server","value":"JUM"},
{"name":"Resolve server","value":"DNS"},
{"name":"Router","value":"RTR"},
{"name":"Switch","value":"SWT"},
{"name":"Web server IIS","value":"IIS"},
{"name":"Web server Other","value":"WEB"}
]
POLICY
  real_time   = false
}
resource "morpheus_select_list_option_type" "technicalService" {

  name                     = "technicalService"
  description              = "Option to select Morpheus group"
  labels                   = ["vmcreation", "terraform_managed"]
  field_name               = "technicalService"
  export_meta              = false
  show_on_edit             = true
  editable                 = false
  display_value_on_details = true
  field_label              = "technicalService"
  help_block               = "Select VM Technical service"
  required                 = true
  option_list_id           = morpheus_manual_option_list.technicalServices.id
}

resource "morpheus_text_option_type" "applicationName" {
  name                     = "applicationName"
  description              = "Name of the application hosted by VM"
  labels                   = ["vmcreation", "terraform_managed"]
  field_name               = "applicationName"
  export_meta              = true
  dependent_field          = "technicalService"
  visibility_field         = "technicalService"
  require_field            = "technicalService"
  show_on_edit             = true
  editable                 = true
  display_value_on_details = true
  field_label              = "Application Name"
  help_block               = "Name of the application hosted by VM"
  required                 = true
}
resource "morpheus_text_option_type" "azRgName" {
  name                     = "ResourceGroupName"
  description              = "Name of the azure rg in wich the VM will be created"
  labels                   = ["vmcreation", "terraform_managed"]
  field_name               = "azcreaterg"
  export_meta              = false
  show_on_edit             = true
  editable                 = true
  display_value_on_details = false
  field_label              = "Azure Resource group name"
  help_block               = "Name of the resource group hosted by VM"
  required                 = false
}
resource "morpheus_text_option_type" "IP" {
  name                     = "IP"
  description              = "IP of VM"
  labels                   = ["vmcreation", "terraform_managed"]
  field_name               = "IP"
  export_meta              = true
  dependent_field          = "parsedNetworks"
  visibility_field         = "parsedNetworks"
  require_field            = "parsedNetworks"
  show_on_edit             = true
  editable                 = true
  display_value_on_details = true
  field_label              = "IP address"
  help_block               = "IP address of the VM previously reserved onto IPAM"
  required                 = true
}
