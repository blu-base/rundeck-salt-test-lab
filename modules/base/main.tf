module "base_backend" {
  source = "../backend/base"

  timezone                 = var.timezone
  ssh_key_path             = var.ssh_key_path
  mirror                   = var.mirror
  use_mirror_images        = var.use_mirror_images
  domain                   = var.domain
  name_prefix              = var.name_prefix
  use_shared_resources     = var.use_shared_resources
  provider_settings        = var.provider_settings
  images                   = var.images
}

output "configuration" {
  value = merge({
    timezone                 = var.timezone
    ssh_key_path             = var.ssh_key_path
    mirror                   = var.mirror
    use_mirror_images        = var.use_mirror_images
    domain                   = var.domain
    name_prefix              = var.name_prefix
    use_shared_resources     = var.use_shared_resources
  }, module.base_backend.configuration)
}
