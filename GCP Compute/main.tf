terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.84.0"
    }
  }
}

provider "google" {
  project                     = var.project
  region                      = var.region
  credentials                 = var.credentials
  #type                        = var.credentials
  #project_id                  = var.credentials
  #private_key_id              = var.credentials
  #private_key                 = var.credentials
  #client_email                = var.credentials
  #client_id                   = var.credentials
  #auth_url                    = var.credentials
  #token_uri                   = var.credentials
  #auth_provider_x509_cert_url = var.credentials
  #client_x509_cert_url        = var.credentials
}

data "google_compute_zones" "available" {
  region = var.region
}

resource "google_compute_address" "public" {
  count = var.assign_public_ip == true ? 1 : 0
  name  = "${var.app_name}-public"
}

resource "google_compute_instance" "vm" {
  name         = var.app_name
  machine_type = var.instance_type
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      size  = var.instance_volume_size
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnetwork_id

    access_config {
      nat_ip = var.assign_public_ip == true ? google_compute_address.public[0].address : null
    }
  }
}

#resource "google_compute_firewall" "inbound-firewall-http" {
#  name    = "${var.app_name}-inbound-allow-http"
#  network = var.network_id

#  priority  = 100
#  direction = "INGRESS"

#  allow {
#    protocol = "tcp"
#    ports    = ["80", "443"]
#  }
#}

#resource "google_compute_firewall" "inbound-deny-other" {
#  name    = "${var.app_name}-inbound-deny-other"
#  network = var.network_id

#  priority  = 65000
#  direction = "INGRESS"

#  deny {
#    protocol = "all"
#  }
#}

#resource "google_compute_firewall" "outbound-allow-http" {
#  name    = "${var.app_name}-outbound-allow-http"
#  network = var.network_id

#  priority  = 100
#  direction = "EGRESS"

#  allow {
#    protocol = "tcp"
#    ports    = ["80", "443"]
#  }
#}

#resource "google_compute_firewall" "outbound-allow-splunk" {
#  name    = "${var.app_name}-outbound-allow-splunk"
#  network = var.network_id

#  priority  = 200
#  direction = "EGRESS"

#  allow {
#    protocol = "tcp"
#    ports    = ["9997"]
#  }
#}

#resource "google_compute_firewall" "outbound-allow-tanium" {
#  name    = "${var.app_name}-outbound-allow-tanium"
#  network = var.network_id

#  priority  = 200
#  direction = "EGRESS"

#  allow {
#    protocol = "tcp"
#    ports    = ["17472"]
#  }
#}

#resource "google_compute_firewall" "outbound-deny-other" {
#  name    = "${var.app_name}-outbound-deny-other"
#  network = var.network_id

#  priority  = 65000
#  direction = "EGRESS"

#  deny {
#    protocol = "all"
#  }
#}
