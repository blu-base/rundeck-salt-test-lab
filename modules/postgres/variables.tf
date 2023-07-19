variable "base_configuration" {
  description = "use module.base.configuration, see the main.tf example file"
  type        = map
}

variable "name" {
  description = "hostname, without the domain part"
  type        = string
}

variable "roles" {
  description = "List of the host roles"
  default     = ["minion", "postgres"]
  type        = set(string)
}

variable "server_configuration" {
  description = "use module.<SERVER_NAME>.configuration, see the main.tf example file"
  type        = map
}

variable "auto_connect_to_master" {
  description = "whether this minion should automatically connect to the Salt Master upon deployment"
  default     = true
  type        = bool
}

variable "disable_firewall" {
  description = "whether to disable the built-in firewall, opening up all ports"
  default     = false
  type        = bool
}

variable "additional_repos" {
  description = "extra repositories used for installation {label = url}"
  default     = {}
  type        = map
}

variable "additional_repos_only" {
  description = "whether to exclusively use additional repos"
  default     = false
  type        = bool
}

variable "additional_packages" {
  description = "extra packages which should be installed"
  default     = []
  type        = list(string)
}

variable "quantity" {
  description = "number of hosts like this one"
  default     = 1
  type        = number
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

variable "additional_grains" {
  description = "custom grain string to be added to this minion's configuration"
  default     = {}
  type        = map
}


variable "image" {
  description = "An image name, e.g. sles12sp4 or opensuse154o"
  type        = string
}

variable "provider_settings" {
  description = "Map of provider-specific settings, see the backend-specific README file"
  default     = {}
  type        = map
}
