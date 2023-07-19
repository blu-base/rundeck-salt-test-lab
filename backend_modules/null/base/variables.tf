variable "timezone" {
  description = "Timezone setting for all VMs"
  default = "Europe/Berlin"
  type = string
}

variable "ssh_key_path" {
  description = "Path of pub ssh key you want to use to access VMs"
  default = "/root/.ssh/id_rsa.pub"
  type = string
}

variable "mirror" {
  description = "Hostname, or hostpath of the mirror, or leave the default for no mirror. Include the protocol, such as https:// or file://"
  default = null
  type = string
}

variable "use_mirror_images" {
  description = "Switch to download images from the mirror source specified in the variable 'mirror'"
  default = false
  type = bool
}

variable "domain" {
  description = "Hostname's domain"
  default = "tf.local"
  type = string
}

variable "name_prefix" {
  description = "A prefix for all names of objects to avoid collisions. E.g. rdslab-"
  default = "rundeck-salt-"
  type = string
}

variable "use_shared_resources" {
  description = "use true to avoid deploying images, mirrors and other shared infrastructure resources"
  default = false
  type = bool
}

variable "provider_settings" {
  description = "Map of provider-specific settings, see the backend_modules/libvirt/README.md"
  default = {}
  type = map
}

variable "images" {
  description = "list of images to be uploaded to the libvirt host"
  default = [ "ubuntu2204o" ]
  type = set(string)
}


