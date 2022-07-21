// Configure the terraform provider
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

// Create VPC
resource "google_compute_network" "vpc" {
 name                    = "${var.name}-vpc"
 auto_create_subnetworks = "false"
}

// Create Subnet
resource "google_compute_subnetwork" "subnet" {
 name          = "${var.name}-subnet"
 ip_cidr_range = "${var.subnet_cidr}"
 network       = "${var.name}-vpc"
 depends_on    = [google_compute_network.vpc]
 region        = "${var.region}"
 
}
// VPC firewall configuration
resource "google_compute_firewall" "firewall" {
  name    = "${var.name}-firewall"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "8200", "1000-4000", "8800"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags=["web"]
}



data "google_compute_image" "debian_9" {
  provider = google-beta
  family  = "debian-9"
  project = "debian-cloud"
}
//Creating Instance Template
resource "google_compute_instance_template" "default" {
  provider = google-beta
  name           = "my-instance-template"
  machine_type   = "e2-standard-4"
  can_ip_forward = false

  tags = ["foo", "bar"]

  disk {
    source_image = data.google_compute_image.debian_9.id
  }

  network_interface {
    network = google_compute_network.vpc.name
	subnetwork = google_compute_subnetwork.subnet.self_link
  }
  scheduling {
	automatic_restart = "true"
	node_affinities {
		key = "compute.googleapis.com/node-group-name"
		operator = "IN"
		values = [google_compute_node_group.nodes.id]
	}
	on_host_maintenance = "MIGRATE"

    preemptible = false
  }

  metadata = {
    foo = "bar"
  }

  
}



//Node template
resource "google_compute_node_template" "soletenant-tmpl" {
  name      = "soletenant-tmpl"
  region    = "us-central1"
  node_type = "n1-node-96-624"
  
  node_affinity_labels = {
    foo = "baz"
  }

}

//Node group
resource "google_compute_node_group" "nodes" {
  name        = "soletenant-group"
  zone        = "us-central1-a"
  description = "example google_compute_node_group for Terraform Google Provider"
  size  = 1
  node_template = google_compute_node_template.soletenant-tmpl.id
}


# [START storage_bucket_tf_with_versioning]
resource "google_storage_bucket" "default" {
  name          = "bucket-tfstate-name"
  force_destroy = false
  location      = "us-central1"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
# [END storage_bucket_tf_with_versioning]