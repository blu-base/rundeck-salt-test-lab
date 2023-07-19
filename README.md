Rundeck/Salt Test Environment

This repository intends to quickly configure test environments with Rundeck and
Saltstack servers, and clients. The structure is derived from the project
[sumaform](https://github.com/uyuni-project/sumaform) from the [Uyuni
Project](https://www.uyuni-project.org/)

The given example configuration creates 4 vm's on a libvirt host: A rundeck
server, a postgres server to be used by rundeck, a saltmaster server, and a
minion.

Currently the post-deployment configuration is unfinished.

## Installation

**Terraform version**: 1.0.10

**Libvirt provider version**: 0.6.3

openSUSE and SUSE Linux Enterprise Server:

```bash
# Uncomment one of the following lines depending on your distro

#sudo zypper addrepo http://download.opensuse.org/repositories/systemsmanagement:/sumaform/openSUSE_Tumbleweed/systemsmanagement:sumaform.repo
#sudo zypper addrepo http://download.opensuse.org/repositories/systemsmanagement:/sumaform/openSUSE_Leap_15.2/systemsmanagement:sumaform.repo
#sudo zypper addrepo http://download.opensuse.org/repositories/systemsmanagement:/sumaform/openSUSE_Leap_15.3/systemsmanagement:sumaform.repo
#sudo zypper addrepo http://download.opensuse.org/repositories/systemsmanagement:/sumaform/SLE_12_SP5/systemsmanagement:sumaform.repo
#sudo zypper addrepo http://download.opensuse.org/repositories/systemsmanagement:/sumaform/SLE_15_SP3/systemsmanagement:sumaform.repo

sudo zypper install git-core
sudo zypper install --from systemsmanagement_sumaform terraform terraform-provider-libvirt
```

Ubuntu and Debian:

```bash
sudo apt install alien
wget http://download.opensuse.org/repositories/systemsmanagement:/sumaform/SLE_15_SP1/x86_64/terraform.rpm
sudo alien -i terraform.rpm
wget http://download.opensuse.org/repositories/systemsmanagement:/sumaform/SLE_15_SP1/x86_64/terraform-provider-libvirt.rpm
sudo alien -i terraform-provider-libvirt.rpm
```

You will need to edit HCL ([HashiCorp Configuration Language](https://github.com/hashicorp/hcl)) files. Syntax highlighting is available in major text editors like [atom](https://atom.io/packages/language-hcl).

## Backend choice

This project can deploy virtual machines to:

- single libvirt hosts
- null backend

The simplest, recommended setup is to use libvirt on your local host. That needs at least 8 GB of RAM in your machine.
If you need a lot of VMs or lack hardware you probably want to use an external libvirt host with bridged networking.

The null backend can be useful in a wide variety of scenarios, for example:

- Test configurations before going live in another supported backend
- Cases in which the virtual infrastructure is outside of the Terraform user's control
- Cover architectures that will maybe never be covered by any other Terraform plugin

Other architectures are currently not intended to be supported.

## Basic `main.tf` configuration

You need define a set of virtual machines in a `main.tf` configuration file,
then run Terraform to have them deployed. Contents of the file vary slightly
depending on the backend you choose. An example is given in `main.tf.example`.

To choose the backend in use one should create a symbolic link to a
`backend_module` module. Refer to the specific READMEs to get started:

- [libvirt README](backend_modules/libvirt/README.md)
- [NULL README](backend_modules/null/README.md)

## Typical use

Refer to the [official guides](https://www.terraform.io/docs/index.html) for a general understanding of Terraform and full commands.

For a very quick start:

```bash
vim main.tf     # change your VM setup
terraform init  # populate modules
terraform validate # check if the configuration is valid
terraform apply # prepare and apply a plan to create your systems (after manual confirmation)
```


# TODOs

* Write the salt states to setup complete environment
  * Salt-master
    * register with salt-master
    * salt-api on master
    * ssl certs for the api
  * Rundeck
    * app installation
    * plugin installtion and configuration
      * salt step
      * salt resource model
  * Postgres
    * initial configuration

