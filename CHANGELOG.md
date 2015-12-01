# Change log

This file contains al notable changes to the bertvv.samba Ansible role.

This file adheres to the guidelines of [http://keepachangelog.com/](http://keepachangelog.com/). Versioning follows [Semantic Versioning](http://semver.org/). "GH-X" refers to the X'th issue on the Github project.

## 2.0.2 - 2015-12-01

### Changed

- The directory `samba_shares_root` is now created befor creating the directories of the shares, with sane permissions set. This fixes GH-3. Contributed by @birgitcroux.

### Removed

- The role variables `create_mask` and `create_directory_mask` were removed. Samba settings `create mask` and `create directory mask` are synonyms for `create mode` and `create directory mode`, respectively. The former name is misleading, because it suggests they work like the Linux command `umask`.

## 2.0.1 - 2015-11-05

### Changed

- The variable type of `samba_create_varwww_symlinks` is now boolean instead of string (GH-1)
- The variable `samba_netbios_name` is no longer required and defaults to `ansible_hostname`.

## 2.0.0 - 2015-11-05

Bugfix release with changes that are not backwards compatible

### Changed

- The variable type of `samba_load_*` is now boolean instead of string, which makes more sense. However, this change is **not backwards compatible**. (GH-1)
- Restart WinBind when changing the configuration (GH-2)
- Updated the base box for the test environment to CentOS 7.1 ([bertvv/centos71](https://atlas.hashicorp.com/bertvv/boxes/centos71/))
- Cleaned up indentation and spaces in the configuration file template

### Removed

- The firewall configuration is no longer set by this role. This also removes the dependency on firewalld.

## 1.0.0 - 2015-03-14

First release

### Added

- Installation
- Create directories
- SELinux settings
- Configuration template with a.o. configurable print sharing, home directories, user access control
- Set user passwords


