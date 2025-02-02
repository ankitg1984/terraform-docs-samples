# [START compute_custom_hostname_instance_create]

resource "google_compute_instance" "custom_hostname_instance" {
  name         = "custom-hostname-instance-name"
  machine_type = "f1-micro"
  zone = "us-central1-c"

  # Set a custom hostname below 
  hostname = "hashicorptest.com"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

# [END compute_custom_hostname_instance_create]
