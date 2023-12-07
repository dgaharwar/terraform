terraform {
  backend "gcs" {
    bucket = "gcs-bel-p-tfstates-001"
    prefix = "morpheus/vmcreation"
  }
}