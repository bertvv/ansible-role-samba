# Change log

This file contains al notable changes to the bertvv.samba Ansible role.

This file adheres to the guidelines of [http://keepachangelog.com/](http://keepachangelog.com/). Versioning follows [Semantic Versioning](http://semver.org/). "GH-X" refers to the X'th issue or pull request on the Github project.

## 2.2.1 - 2016-10-29

### Added

- (GH-12) Add the ability to set owner to the path (credit: [Paul Montero](https://github.com/lpaulmp))

### Changes

- Added tags to all tasks

## 2.2.0 - 2016-07-29

### Added

- (GH-11) Introduced variable `samba_interfaces` (credit: [Jonas Heinrich](https://github.com/onny))
- (GH-11) Added support for Arch Linux (credit: [Jonas Heinrich](https://github.com/onny))

## 2.1.1 - 2016-05-29

This is a bugfix release.

### Changed

- (GH-6) Made creation of Samba users idempotent. The task "Create Samba users [...]" will now only indicate it has changed when it actually created a user.
- (GH-9) Fixed forgotten `when: samba_create_varwww_symlinks` (credit: [DarkStar1973](https://github.com/DarkStar1973))

## 2.1.0 - 2016-05-12

### Added

- (GH-7) Support for Debian/Ubuntu (credit: [Ian Young](https://github.com/iangreenleaf)) and Fedora.
- Vagrant test environment for all supported platforms

### Changed

- Moved test code to a separate branch
- (GH-8) Fixed deprecation warnings in Ansible 2.0 (partial credit: [Ian Young](https://github.com/iangreenleaf))
- Use the generic `package:` module introduced in Ansible 2.0.

### Removed

- The `version:` field in `meta/main.yml` was removed because it is no longer accepted in Ansible 2.0. Unfortunately, this change breaks compatibility with `librarian-ansible`. For more info on this issue, see [ansible/ansible#](https://github.com/ansible/ansible/issues/13496).

## 2.0.2 - 2015-12-01

### Changed

- The directory `samba_shares_root` is now created befor creating the directories of the shares, with sane permissions set. This fixes GH-3. Contributed by @birgitcroux.

### Removed

- The role variables `create_mask` and `create_directory_mask` were removed. Samba settings `create mask` and `create directory mask` are synonyms for `create mode` and `create directory mode`, respectively. The former name is misleading, because it suggests they work like the Linux command `umask`.

## 2.0.1 - 2015-11-05

### Changed

- (GH-1) The variable type of `samba_create_varwww_symlinks` is now boolean instead of string
- The variable `samba_netbios_name` is no longer required and defaults to `ansible_hostname`.

## 2.0.0 - 2015-11-05

Bugfix release with changes that are not backwards compatible

### Changed

- (GH-1) The variable type of `samba_load_*` is now boolean instead of string, which makes more sense. However, this change is **not backwards compatible**.
- (GH-2) Restart WinBind when changing the configuration
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


