terraform {
  backend "gcs" {
    bucket = "dg-morpheusapp-bucket"
    prefix = "morpheus/vmcreation"
  }
}