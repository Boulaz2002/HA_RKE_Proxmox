variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "vmid" {
  description = "The unique VM ID in Proxmox"
  type        = number
}

variable "memory" {
  description = "Amount of RAM in MB for the VM"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores for the VM"
  type        = number
}

variable "ip_address" {
  description = "IP address assigned to the VM"
  type        = string
}

variable "node" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "disk_size" {
  description = "Disk size for the VM (e.g., '50G')"
  type        = string
}

variable "cloud_init_file" {
  description = "Cloud-Init configuration file for the VM"
  type        = string
}

variable "storage" {
  description = "The storage location for the VM disk (e.g., 'local-lvm')"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "The network bridge interface for the VM"
  type        = string
  default     = "vmbr0"
}

variable "gateway" {
  description = "The default gateway for the VM"
  type        = string
  default     = "192.168.1.1"
}

variable "ciuser" {
  description = "Cloud-Init user for the VM"
  type        = string
  default     = "ubuntu"
}

# variable "ssh_public_key" {
#   description = "SSH public key for user authentication"
#   type        = string
# }
