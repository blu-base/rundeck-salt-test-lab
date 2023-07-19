locals {
  images_used = var.use_shared_resources ? [] : var.images
  image_urls = {
    ubuntu2204o = "${var.use_mirror_images ? var.mirror : "https://cloud-images.ubuntu.com/jammy/current"}/jammy-server-cloudimg-amd64.img"
  }
  pool = lookup(var.provider_settings, "pool", "rundeck-salt")
  network_name = lookup(var.provider_settings, "network_name", "rundeck-salt")
  bridge = lookup(var.provider_settings, "bridge", null)
  additional_network = lookup(var.provider_settings, "additional_network", null)
}

resource "libvirt_volume" "volumes" {
  for_each = local.images_used

  name = "${var.name_prefix}${each.value}"
  source = local.image_urls[each.value]
  pool = local.pool
}

resource "libvirt_network" "additional_network" {
  count = local.additional_network == null ? 0 : 1
  name = "${var.name_prefix}private"
  mode = "none"
  addresses = [local.additional_network]
  dhcp {
    enabled = "false"
  }
  autostart = "true"
}

output "configuration" {
  depends_on = [
    libvirt_volume.volumes,
    libvirt_network.additional_network,
  ]
  value = {
    additional_network = local.additional_network
    additional_network_id = join(",", libvirt_network.additional_network[*].id)

    pool = local.pool
    network_name = local.bridge == null ? local.network_name : null
    bridge = local.bridge
  }
}
