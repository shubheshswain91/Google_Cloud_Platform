module "instances" {
  source     = "./modules/instances"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  network_name  = module.vpc.network_name
  subnet_1_name = module.vpc.subnets_names[0]
  subnet_2_name = module.vpc.subnets_names[1]
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

terraform {
  backend "gcs" {
    bucket = "tf-bucket-663730"
    prefix = "terraform/state"
  }
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "13.0.0"

  project_id   = var.project_id
  network_name = "tf-vpc-252170"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "us-west1"
    }
  ]
}

resource "google_compute_firewall" "tf-firewall" {
  name         = "tf-firewall"
  network      = module.vpc.network_name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}