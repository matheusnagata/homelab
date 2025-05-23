# variables.tf

variable "vmws_user" {
  description = "Username for the VMware Workstation REST API"
  type        = string
  sensitive   = true # Mark as sensitive to prevent showing in logs
}

variable "vmws_password" {
  description = "Password for the VMware Workstation REST API"
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "vmws_url" {
  description = "URL of the VMware Workstation REST API"
  type        = string
  default     = "http://localhost:8697/api" # Default for most setups
}

variable "vmws_path" {
  description = "Path where VMware Workstation stores VM files (e.g., C:\\Users\\YourUser\\Documents\\Virtual Machines)"
  type        = string
  # Example for Windows: "C:\\Users\\YourUser\\Documents\\Virtual Machines"
  # Example for Linux: "/home/youruser/vmware"
  # IMPORTANT: For Windows, use double backslashes (\\)
  # Or, you can set this directly when prompted or via an environment variable.
}

variable "source_vm_id" {
  description = "ID of the source VM to clone from (e.g., vms/12345678-abcd-efgh-ijkl-1234567890ab)"
  type        = string
}