# Advanced `main.tf` configurations

## Changing Operating Systems

You can specify a base OS in most modules specifying an `image` variable.

For some modules like `minion`, `image` is mandatory and Terraform will refuse to apply plans if it is missing. Please refer to `modules/<backend>/base/main.tf` for the exact list of supported OSs.

For other modules like `server` there is a default selection if nothing is specified. Please note that not all OS combinations might be supported, refer to official documentation to select a compatible OS.

```hcl
module "minion" {
  source = "./modules/minion"
  base_configuration = module.base.configuration

  image = "ubuntu2204o"
  name = "minion"
}
```

### Official OS images

Many projects/vendors provide official OS images for the various backends, and sumaform uses them when available. The name for those images is suffixed with an "o" (eg. `ubuntu2204o`).

## Switching to another backend

Changing the backend normally means destroying the current one (see "Working on multiple configuration sets" to maintain multiple).

The following steps need to be performed:

- Clean the current Terraform state
  - Consider run `terraform destroy`
  - Remove the `terraform.tfstate` file
- Adapt the `main.tf` file to the new provider specific properties
- remove folder `.terraform`
- Create a new backend symbolic link to point to the new backend. From the `modules` folder run:

```bash
ln -sfn ../backend_modules/<BACKEND> modules/backend
```

## Multiple VMs of the same type

Some modules, for example clients and minions, support a `quantity` variable that allows you to create several instances at once. For example:

```hcl
module "minion" {
  source = "./modules/minion"
  base_configuration = module.base.configuration

  name = "min-ubuntu2204"
  image = "ubuntu2204o"
  server_configuration = module.server.configuration
  quantity = 10
}
```

This will create 10 minions connected to the `minion`.

## Turning convenience features off

By default, sumaform deploys hosts with a range of tweaked settings for convenience reasons. If in your use case this is not wanted, you can turn those off via the following variables.

 * `client` module:
   * `auto_register`: automatically registers clients to the SUSE Manager Server. Set to `false` for manual registration
   * `disable_firewall`: disables the firewall making all ports available to any host. Set to `false` to only have typical SUSE Manager ports open
   * `sles_registration_code` : only for sles, register client with SCC key and enable modules during deployment. Set to `null` by default to use repositories for deployment  
 * `minion` module:
   * `auto_connect_to_master`: automatically connects to the Salt Master. Set to `false` to manually configure
   * `disable_firewall`: disables the firewall making all ports available to any host. Set to `false` to only have typical SUSE Manager ports open
   * `sles_registration_code` : only for sles, register client with SCC key and enable modules during deployment. Set to `null` by default to use repositories for deployment
 * `sshminion` module:
   * `disable_firewall`: disables the firewall making all ports available to any host. Set to `false` to only have typical SUSE Manager ports open
 * `host` module:
   * `disable_firewall`: disables the firewall making all ports available to any host. Set to `false` to only have typical SUSE Manager ports open
 * `proxy` module:
   * `minion`: whether to configure this Proxy as a Salt minion. Set to `false` to have the Proxy set up as a traditional client
   * `auto_connect_to_master`: automatically connects to the Salt Master. Set to `false` to manually configure. Requires `minion` to be `true`
   * `auto_register`: automatically registers the proxy to its upstream Server or Proxy. Defaults to `false`, requires `minion` to be `false`
   * `download_private_ssl_key`: automatically copies SSL certificates from the upstream SUSE Manager Server or SUSE Manager Proxy. Requires `publish_private_ssl_key` on the upstream server or proxy. Set to `false` for manual distribution
   * `install_proxy_pattern`: install proxy pattern with all proxy-related software. Set to `false` to install manually
   * `auto_configure`: automatically runs the `confure-proxy.sh` script which enables Proxy functionality. Set to `false` to run manually. Requires `auto_register`, `download_private_ssl_key`, and `install_proxy_pattern`
   * `generate_bootstrap_script`: generates a bootstrap script for traditional clients and copies it in /pub. Set to `false` to generate manually. Requires `auto_configure`
   * `publish_private_ssl_key`: copies the private SSL key in /pub for cascaded Proxies to copy automatically. Set to `false` for manual distribution. Requires `download_private_ssl_key`
   * `disable_firewall`: disables the firewall making all ports available to any host. Set to `false` to only have typical SUSE Manager ports open
   * `proxy_registration_code` : register proxy with SCC key and enable modules needed for SUMA Proxy during deployment. Set to `null` by default to use repositories for deployment
 * `server` module:
   * `auto_accept`: whether to automatically accept minion keys. Set to `false` to manually accept
   * `create_first_user`: whether to automatically create the first user (the SUSE Manager Admin)
     * `server_username` and `server_password`: define credentials for the first user, admin/admin by default
   * `disable_firewall`: disables the firewall making all ports available to any host. Set to `false` to only have typical SUSE Manager ports open
   * `allow_postgres_connections`: configure Postgres to accept connections from external hosts. Set to `false` to only allow localhost connections
   * `unsafe_postgres`: use PostgreSQL settings that improve performance by worsening durability. Set to `false` to ensure durability
   * `skip_changelog_import`: import RPMs without changelog data, this speeds up spacewalk-repo-sync. Set to `false` to import changelogs
   * `mgr_sync_autologin`: whether to set mgr-sync credentials in the .mgr-sync file. Requires `create_first_user`
   * `create_sample_channel`: whether to create an empty test channel. Requires `create_first_user`
   * `create_sample_activation_key`: whether to create a sample activation key. Requires `create_first_user`
   * `create_sample_bootstrap_script`: whether to create a sample bootstrap script for traditional clients. Requires `create_sample_activation_key`
   * `publish_private_ssl_key`: copies the private SSL key in /pub for Proxies to copy automatically. Set to `false` for manual distribution
   * `disable_download_tokens`: disable package token download checks. Set to `false` to enable checking
   * `forward_registration`: enable forwarding of registrations to SCC (default off)
   * `server_registration_code` : register server with SCC key and enable modules needed for SUMA Server during deployment. Set to `null` by default to use repositories for deployment
   * `login_timeout`: define how long the webUI login cookie is valid (in seconds). Set to null by default to leave it up to the application default value.
   * `db_configuration` : pass external database configuration to change `setup_env.sh` file. See more in `Using external database` section


## Shared resources, prefixing, sharing virtual hardware

Whenever multiple sumaform users deploy to the same virtualization hardware (eg. libvirt host) it is recommended to set the `name_prefix` variable in the `base` module in order to have a unique per-user prefix for all resource names. This will prevent conflicting names.

Additionally, it is possible to have only one user to upload images and other shared infrastructure such as mirrors, having all other users re-use them. In order to accomplish this:

- add a `use_shared_resources = true` variable to the `base` module of all users but one
- make sure there is exactly one user that does not have the variable set, make sure this user has no `name_prefix` set. This user will deploy shared infrastructure for all users

## Custom SSH keys

If you want to use another key for all VMs, specify the path of the public key with `ssh_key_path` into the `base` config. Example:

```hcl
module "base" {
  ...
  ssh_key_path = "~/.ssh/id_mbologna_terraform.pub"
  ...
}
```

The `ssh_key_path` option can also be specified on a per-host basis. In this case, the key specified is treated as an additional key, copied to the machine as well as the `ssh_key_path` specified in the `base` section.

If you don't want to copy any ssh key at all (and use passwords instead), just supply an empty file (eg. `ssh_key_path = "/dev/null"`).

## SSH access without specifying a username

You can add the following lines to `~/.ssh/config` to avoid checking hosts and specifying a username:

```config
Host *.tf.local
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
User root
```

## Working on multiple configuration sets (workspaces) locally

Terraform supports working on multiple infrastructure resource groups with the same set of files through the concept of [workspaces](https://www.terraform.io/docs/state/workspaces.html). Unfortunately those are not supported for the default filesystem backend and do not really work well with different `main.tf` files, which is often needed in sumaform.

As a workaround, you can create a `local_workspaces` directory with a subdirectory per workspace, each containing main.tf and terraform.tfstate files, then use symlinks to the sumaform root:

```bash
~/sumaform$ find local_workspaces/
local_workspaces/
local_workspaces/aws-demo
local_workspaces/aws-demo/main.tf
local_workspaces/aws-demo/terraform.tfstate
local_workspaces/libvirt-testsuite
local_workspaces/libvirt-testsuite/main.tf
local_workspaces/libvirt-testsuite/terraform.tfstate
~/sumaform$ ls -l main.tf
... main.tf -> local_workspaces/libvirt-testsuite/main.tf
~/sumaform$ ls -l terraform.tfstate
... -> local_workspaces/libvirt-testsuite/terraform.tfstate
```
