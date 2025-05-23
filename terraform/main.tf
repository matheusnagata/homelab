# main.tf

terraform {
  required_providers {
    vmworkstation = {
      source = "elsudano/vmworkstation"
      version = ">= 1.1.6" # Always use the latest stable version if possible
    }
  }
  required_version = ">= 1.0.0" # Ensure you have a compatible Terraform version
}

provider "vmworkstation" {
  user     = var.vmws_user
  password = var.vmws_password
  url      = var.vmws_url
  debug = true # Uncomment for more verbose logging from the provider
  # https = false # If you are not using HTTPS for the API, set this to false (default often is).
}

resource "vmworkstation_vm" "my_new_vm" {
  sourceid    = var.source_vm_id # ID of the VM to clone from
  denomination = "MyTerraformVM" # Name of the new VM
  description  = "A VM created and managed by Terraform on VMware Workstation"
  memory = "2048" # RAM in MB (e.g., 2GB)
  processors = "2"    # Number of virtual CPUs
  path = var.vmws_path
  state = "off"
}