provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

## API's
resource "google_project_service" "compute_service" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

## Network
#  the default networks in this Org do not get created due to a good restraint
#  external IP's are not permitted!
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.compute_service
  ]
}

resource "google_compute_subnetwork" "subnet" {
  name          = "tiny-net"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc_network.id
}

## Cloud Nat
resource "google_compute_router" "router" {
  name    = "tiny-router"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "tiny-router-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

## Firewall
resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

## GCE Nginx
resource "google_compute_instance" "vm_nginx" {
  name         = "nginx"
  machine_type = "e2-micro"

  tags = ["web"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
  }

  metadata_startup_script = <<SCRIPT
    sudo apt-get update
    sudo apt-get -y install nginx
    nginx -v
    sudo systemctl enable nginx
    sudo systemctl status nginx
    SCRIPT
}

## GCE Nginx Consumer
resource "google_compute_instance" "vm_nginx_consumer" {
  name         = "nginx-consumer"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
  }
}
