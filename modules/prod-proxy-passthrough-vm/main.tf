locals {
  // extract useful global config values
  assigned_ips            = module.config.ip_addresses
  assigned_vmids          = module.config.vmids
  harbormaster_repository = module.config.github_harbormaster_repository_url
  datastore_cloudinit     = module.config.proxmox_datastore_hdd
  datastore_snippets      = module.config.proxmox_datastore_snippets
  datastore_ssd           = module.config.proxmox_datastore_ssd
  iso_ids                 = module.config.iso_ids
  proxmox_node            = module.config.proxmox_default_node
  all_users               = module.config.all_users

  // module specific config
  vm_name             = "prod-proxy-passthrough"
  boot_disk_datastore = local.datastore_ssd
  boot_disk_iso       = local.iso_ids.ubuntu_2204_20240126
  ip_address          = lookup(local.assigned_ips, local.vm_name, null)
  users               = local.all_users
  vmid                = lookup(local.assigned_vmids, local.vm_name, null)

  network_config = local.ip_address == null ? null : {
    ip_address        = local.ip_address
    gateway           = "10.111.1.1"
    dns_search_domain = "home.pegasuspad.com"
  }
}

module "config" {
  source = "../_config"
}

module "harbormaster" {
  source = "github.com/pegasuspad/tf-modules.git//modules/cloudinit-harbormaster-install?ref=main"

  host_name  = local.vm_name
  repository = local.harbormaster_repository
}

module "virtual_machine" {
  source = "github.com/pegasuspad/tf-modules.git//modules/proxmox-virtual-machine?ref=main"

  boot_iso_id          = local.boot_disk_iso
  cloud_init_datastore = local.datastore_cloudinit
  cloud_init_tasks     = module.harbormaster.tasks
  memory               = 512
  name                 = local.vm_name
  network_config       = local.network_config
  proxmox_node         = local.proxmox_node
  snippets_datastore   = local.datastore_snippets
  tags                 = ["infrastructure", "prod"]
  users                = local.users
  vmid                 = local.vmid

  boot_disk = {
    datastore = local.boot_disk_datastore
    size      = 32
    ssd       = local.boot_disk_datastore == local.datastore_ssd
  }
}
