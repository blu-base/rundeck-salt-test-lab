
resource "null_resource" "base" {
  # Changes here requires re-provisioning
  triggers = {
    timezone = var.timezone
    ssh_key_path = var.ssh_key_path
    mirror = var.mirror
    use_mirror_images = var.use_mirror_images
    domain = var.domain
    name_prefix          = var.name_prefix
    use_shared_resources = var.use_shared_resources
    provider_settings    = yamlencode(var.provider_settings)
    images               = yamlencode(var.images)
  }
}

output "configuraton" {
  value = {
    timezone = var.timezone
    use_ntp = var.use_ntp
    ssh_key_path = var.ssh_key_path
    mirror = var.mirror
    use_mirror_images = var.use_mirror_images
    domain = var.domain
    name_prefix          = var.name_prefix
    use_shared_resources = var.use_shared_resources
  }
}
