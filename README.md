# prod-infrastructure

Terraform modules defining the Pegasus "homeprod" infrastructure.

## Patterns and Conventions

### Glossary

- `data VM`: a data VM is a Proxmox virtual machine with no OS installed which is never intended to be booted. Instead, it is used to provisions disks that are attached to another (bootable) VM. The purpose of this is to allowable the bootable VM to be destroyed and recreated without losing the persistent disks. This pattern is illustrated in the documentation for our Terraform provider: https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#example-attached-disks

### Naming Conventions

- Module names ending in `-vm` create a Proxmox VM. The VM name is the module name, excluding this suffix.

