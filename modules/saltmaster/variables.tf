variable "base_configuration" {
  description = "use module.base.configuration, see the main.tf example file"
  type        = map
}

variable "name" {
  description = "hostname, without the domain part"
  type        = string
}

variable "download_private_ssl_key" {
  description = "copy SSL certificates from the hub server upon deployment"
  default     = true
  type        = bool
}

variable "disable_firewall" {
  description = "whether to disable the built-in firewall, opening up all ports"
  default     = true
  type        = bool
}

variable "additional_repos" {
  description = "extra repositories in the form {label = url}, see README_ADVANCED.md"
  default     = {}
  type        = map
}

variable "additional_repos_only" {
  description = "whether to exclusively use additional repos"
  default     = false
  type        = bool
}

variable "additional_certs" {
  description = "extra SSL certficates in the form {name = url}, see README_ADVANCED.md"
  default     = {}
  type        = map
}

variable "additional_packages" {
  description = "extra packages to install, see README_ADVANCED.md"
  default     = []
  type        = list(string)
}

variable "swap_file_size" {
  description = "Swap file size in MiB, or 0 for none"
  default     = 0
  type        = number
}

variable "ssh_key_path" {
  description = "path of additional pub ssh key you want to use to access VMs, see README_ADVANCED.md"
  default     = null
  type        = string
}

variable "gpg_keys" {
  description = "salt/ relative paths of gpg keys that you want to add to your VMs, see README_ADVANCED.md"
  default     = []
  type        = list(string)
}

variable "ipv6" {
  description = "IPv6 tuning: enable it, accept the RAs"
  default = {
    enable    = true
    accept_ra = true
  }
  type        = map
}

variable "image" {
  description = "Leave default for automatic selection or specify an OS supported by the specified product version"
  default     = "default"
  type        = string
}

variable "provider_settings" {
  description = "Map of provider-specific settings, see the backend-specific README file"
  default     = {}
  type        = map
}

variable "volume_provider_settings" {
  description = "Map of volume-provider-specific settings, see the backend-specific README file"
  default     = {}
  type        = map
}
