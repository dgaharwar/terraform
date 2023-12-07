resource "morpheus_instance_type" "w2019" {
  name               = "BEL - Windows 2019"
  code               = "belw2019"
  description        = "Windows server 2019 built for BEL"
  labels             = ["terraform_managed", "vmcreation", "w2019"]
  category           = "os"
  visibility         = "public"
  featured           = true
  enable_deployments = true
  enable_scaling     = false
  enable_settings    = true
  environment_prefix = "BELW2019_"
}

resource "morpheus_instance_layout" "azr_w2019" {
  instance_type_id = morpheus_instance_type.w2019.id
  name             = "BEL - AZR -WINDOWS 2019"
  labels           = ["terraform_managed", "azure", "office", "vmcreation"]
  version          = "23.11"
  technology       = "azure"
  minimum_memory   = 2048
  creatable        = true
  option_type_ids  = [morpheus_text_option_type.azRgName.id]
  workflow_id      = morpheus_provisioning_workflow.createrg.id
  node_type_ids    = [
    morpheus_node_type.azr_w2019.id
  ]
}

resource "morpheus_node_type" "azr_w2019" {
  category = "os"
  labels           = ["azure", "office", "vmcreation", "terraform_managed"]
  name             = "BEL - Azure office image"
  short_name       = "azr-w2k19"
  technology       = "azure"
  version          = "0.11"
  virtual_image_id = data.morpheus_virtual_image.azr_w2019_latest.id
}
moved {
  from = morpheus_node_type.w2019
  to   = morpheus_node_type.azr_w2019
}
resource "morpheus_python_script_task" "createrg" {
  name                = "vmcreation-task-createAzureRG"
  code                = "createazurerg"
  labels              = ["vmcreation", "terraform_managed", "azure", "office"]
  source_type         = "local"
  script_content      = file("${path.module}/data/azCreateRG.py")
  additional_packages = "requests"
  python_binary       = "/bin/python3"
  retryable           = false
  retry_count         = 3
  retry_delay_seconds = 60
  allow_custom_config = true
}
resource "morpheus_provisioning_workflow" "createrg" {
  name        = "vmcreation-workflow-createAzureRG"
  description = "Terraform provisioning workflow example"
  labels      = ["vmcreation", "terraform_managed", "azure", "office"]
  platform    = "all"
  visibility  = "private"
  task {
    task_id    = morpheus_python_script_task.createrg.id
    task_phase = "configure"
  }
}