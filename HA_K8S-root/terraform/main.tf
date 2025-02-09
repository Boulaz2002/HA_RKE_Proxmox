# provider "proxmox" {
#   pm_api_url      = "https://YOUR-PROXMOX-IP:8006/api2/json"
#   pm_user         = "root@pam"
#   pm_password     = "YOUR-PROXMOX-PASSWORD"
#   pm_tls_insecure = true  # Set to false if using valid SSL certs
# }

# variable "vm_config" {
#   type = list(object({
#     name        = string
#     vmid        = number
#     memory      = number
#     cores       = number
#     ip_address  = string
#     node        = string
#     disk_size   = string
#   }))
#   default = [
#     { name = "master-1", vmid = 101, memory = 4096, cores = 2, ip_address = "192.168.0.101", node = "pve", disk_size = "50G" },
#     { name = "master-2", vmid = 102, memory = 4096, cores = 2, ip_address = "192.168.0.102", node = "proxmox", disk_size = "50G" },
#     { name = "master-3", vmid = 103, memory = 4096, cores = 2, ip_address = "192.168.0.103", node = "proxmox", disk_size = "50G" },
#     { name = "worker-1", vmid = 104, memory = 4096, cores = 2, ip_address = "192.168.0.104", node = "proxmox", disk_size = "50G" },
#     { name = "worker-2", vmid = 105, memory = 4096, cores = 2, ip_address = "192.168.0.105", node = "proxmox", disk_size = "50G" },
#     { name = "worker-3", vmid = 106, memory = 4096, cores = 2, ip_address = "192.168.0.106", node = "proxmox", disk_size = "50G" },
#     { name = "haproxy", vmid = 107, memory = 2048, cores = 1, ip_address = "192.168.0.100", node = "proxmox", disk_size = "20G" }
#   ]
# }

# resource "proxmox_vm_qemu" "rke2_nodes" {
#   for_each = { for vm in var.vm_config : vm.name => vm }

#   name        = each.value.name
#   vmid        = each.value.vmid
#   target_node = each.value.node
#   memory      = each.value.memory
#   cores       = each.value.cores
#   boot        = "order=scsi0"

#   disk {
#     size    = each.value.disk_size
#     type    = "scsi"
#     storage = "local-lvm"
#   }

#   network {
#     model  = "virtio"
#     bridge = "vmbr0"
#   }

#   ipconfig0 = "ip=${each.value.ip_address}/24,gw=192.168.1.1"
#   os_type   = "cloud-init"
# }



# module "worker-1" {
#   source         = "./modules/proxmox-vm"
#   name           = "worker-1"
#   vmid           = 104
#   memory         = 4096
#   cores          = 2
#   ip_address     = "192.168.1.104"
#   node           = "proxmox"
#   disk_size      = "50G"
#   cloud_init_file = "cloud-init-worker.yaml"
# }

module "worker-1" {
  source = "./modules/proxmox-vm"
  name = "worker-1"
  vmid = 100
  node = "pve"
  memory = 4096
  cores = 4
  disk_size = "20G"
  ip_address = "192.168.0.121"
  cloud_init_file = ""
  ssh_public_key = ""
}