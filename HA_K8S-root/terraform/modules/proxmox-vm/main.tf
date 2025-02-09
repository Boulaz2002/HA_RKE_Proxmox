resource "proxmox_vm_qemu" "rke2_nodes" {
  name        = var.name
  vmid        = var.vmid
  target_node = var.node
  memory      = var.memory
  cores       = var.cores
  boot        = "order=scsi0"

  disk {
    size    = var.disk_size
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
  }

  ipconfig0 = "ip=${var.ip_address}/24,gw=${var.gateway}"
  os_type   = "cloud-init"

  cloudinit_cdrom_storage = "local-lvm"

  # Use only cicustom for Cloud-Init configuration
  cicustom = "user=local:snippets/cloud-init-userdata.yaml,meta=local:snippets/cloud-init-meta.yaml,network=local:snippets/cloud-init-network.yaml"
}
