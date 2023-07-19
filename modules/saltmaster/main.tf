module "saltmaster" {
  source = "../host"

  base_configuration            = var.base_configuration
  name                          = var.name
  additional_repos              = var.additional_repos
  additional_repos_only         = var.additional_repos_only
  additional_certs              = var.additional_certs
  additional_packages           = var.additional_packages
  swap_file_size                = var.swap_file_size
  ssh_key_path                  = var.ssh_key_path
  gpg_keys                      = var.gpg_keys
  ipv6                          = var.ipv6
  connect_to_base_network       = true
  connect_to_additional_network = false
  roles                         = ["saltmaster"]
  disable_firewall              = var.disable_firewall
  grains = {
    mirror                 = var.base_configuration["mirror"]
    download_private_ssl_key       = var.download_private_ssl_key
  }


  image                    = var.image
  provider_settings        = var.provider_settings
  volume_provider_settings = var.volume_provider_settings
}

output "configuration" {
  value = {
    id              = length(module.saltmaster.configuration["ids"]) > 0 ? module.saltmaster.configuration["ids"][0] : null
    hostname        = length(module.saltmaster.configuration["hostnames"]) > 0 ? module.saltmaster.configuration["hostnames"][0] : null
  }
}
