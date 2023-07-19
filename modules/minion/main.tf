
module "minion" {
  source = "../host"

  base_configuration            = var.base_configuration
  name                          = var.name
  roles                         = var.roles
  additional_repos              = var.additional_repos
  additional_repos_only         = var.additional_repos_only
  //additional_certs              = var.additional_certs
  additional_packages           = var.additional_packages
  quantity                      = var.quantity
  swap_file_size                = var.swap_file_size
  ssh_key_path                  = var.ssh_key_path
  gpg_keys                      = var.gpg_keys
  ipv6                          = var.ipv6
  connect_to_base_network       = true
  connect_to_additional_network = true
  image             = var.image
  disable_firewall              = var.disable_firewall

  grains = merge({
    auto_connect_to_master = var.auto_connect_to_master
  }, var.additional_grains)

  provider_settings = var.provider_settings
}

output "configuration" {
  value = module.minion.configuration
}
