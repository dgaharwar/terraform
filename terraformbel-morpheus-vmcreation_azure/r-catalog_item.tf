resource "morpheus_instance_catalog_item" "vmcreation_azure" {
  config      = file("data/vmcreation_azure-config.json")
  content     = "Windows Catalog Item :"
  description = "A catalog item used to deploy a virtual machine on a BEL environment"
  enabled     = true
  featured    = true
  # image_name      = null
  # image_path      = "windows.svg"
  labels = ["vmcreation", "terraform_managed"]
  name   = "Create Azure VM TF"
  option_type_ids = [morpheus_text_option_type.azRgName.id,morpheus_select_list_option_type.technicalService.id,morpheus_text_option_type.applicationName.id]
 #option_type_ids = [morpheus_select_list_option_type.technicalService.id,morpheus_text_option_type.applicationName.id,morpheus_select_list_option_type.azrPlan.id,morpheus_select_list_option_type.azrCloud.id]
  visibility = "public"
}
