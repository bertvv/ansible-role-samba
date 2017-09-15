# Ansible role `bertvv.samba`

[![Build Status](https://travis-ci.org/bertvv/ansible-role-samba.svg?branch=master)](https://travis-ci.org/bertvv/ansible-role-samba)

An Ansible role for setting up Samba as a file server. It is tested on CentOS, Debian, Ubuntu and Arch Linux. Specifically, the responsibilities of this role are to:

- Install the necessary packages
- Configure SELinux settings (when SELinux is active)
- Create share directories
- Manage Samba users and passwords
- Manage access to shares

The following are not considered concerns of this role, and you should configure these using another role (e.g. [bertvv.rh-base](https://galaxy.ansible.com/bertvv/rh-base/):

- Managing firewall settings.
- Creating system users. Samba users should already exist as system users.

**If you like/use this role, please consider giving it a star! Thanks!**

## CVE-2017-7494

A recently discovered remote code execution vulnerability may affect your Samba server installation.

If SELinux is enabled on your system, it is **NOT** vulnerable.

Version 2.3.1 of this role has a fix for the vulnerability. Upgrade your system if necessary.

More info: <https://access.redhat.com/security/cve/cve-2017-7494>

## Requirements

No specific requirements

## Role Variables

| Variable                       | Default                  | Comments                                                              |
| :---                           | :---                     | :---                                                                  |
| `samba_create_varwww_symlinks` | false                    | When true, symlinks are created in `/var/www/html` to the shares.     |
| `samba_interfaces`             | []                       | List of network interfaces used for browsing, name registration, etc. |
| `samba_load_homes`             | false                    | When true, user home directories are accessible.                      |
| `samba_load_printers`          | false                    | When true, printers attached to the host are shared                   |
| `samba_log`                    | -                        | Set the log file. If left undefined, logging is done through syslog.  |
| `samba_log_size`               | 5000                     | Set the maximum size of the log file.                                 |
| `samba_map_to_guest`           | `bad user`               | Behaviour when unregistered users access the shares.                  |
| `samba_netbios_name`           | `{{ ansible_hostname }}` | The NetBIOS name of this server.                                      |
| `samba_passdb_backend`         | `tdbsam`                 | Password database backend.                                            |
| `samba_security`               | `user`                   | Samba security setting                                                |
| `samba_server_string`          | `fileserver %m`          | Comment string for the server.                                        |
| `samba_shares`                 | []                       | List of dicts containing share definitions. See below for details.    |
| `samba_shares_root`            | `/srv/shares`            | Directories for the shares are created under this directory.          |
| `samba_users`                  | []                       | List of dicts defining users that can access shares.                  |
| `samba_workgroup`              | `WORKGROUP`              | Name of the server workgroup.                                         |
| `samba_guest_account`          | -                        | Guest account for unknown users                                       |
| `samba_wins_support`           | true                     | When true, Samba will act as a WINS server                            |
| `samba_local_master`           | true                     | When true, nmbd will try & become local master of the subnet          |
| `samba_domain_master`          | true                     | When true, smbd enables WAN-wide browse list collation                |
| `samba_preferred_master`       | true                     | When true, indicates nmbd is a preferred master browser for workgroup |

### Defining users

In order to allow users to access the shares, they need to get a password specifically for Samba:

```Yaml
samba_users:
  - name: alice
    password: ecila
  - name: bob
    password: bob
  - name: charlie
    password: eilrahc
```

Unfortunately, passwords have to be in plain text for now. Also, remark that this role will not change the password of an existing user.

These users should already have an account on the host! Creating system users is not a concern of this role, so you should do this separately. A possibility is my role [bertvv.rh-base](https://galaxy.ansible.com/bertvv/rh-base/). An example:

```Yaml
rhbase_users:
  - name: alice
    comment: 'Alice'
    password: !!
    shell: /sbin/nologin
    groups:
      [...]
```

This user is not allowed to log in on the system (e.g. with SSH) and would only get access to the Samba shares.

### Defining shares

Defining Samba shares and configuring access control can be challenging, since it involves not only getting the Samba configuration right, but also user and file permissions, and SELinux settings. This role attempts to simplify the process.

To specify a share, you should at least give it a name:

```Yaml
samba_shares:
  - name: readonlyshare
```

This will create a share with only read access for registered users. Guests will not be able to see the contents of the share.


A good way to configure write access for a share is to create a system user group, add users to that group, and make sure they have write access to the directory of the share. This role assumes groups are already set up and users are members of the groups that control write access. Let's assume you have two users `jack` and `teach`, members of the group `pirates`. This share definition will give both read and write access to the `pirates`:

```Yaml
samba_shares:
  - name: piratecove
    comment: 'A place for pirates to hang out'
    group: pirates
    write_list: +pirates
```

Guests have no access to this share, registered users can read. You can further tweak access control. Read access can be extended to guests (add `public: yes`) or restricted to specified users or groups (add `valid_users: +pirates`). Write access can be restricted to individual pirates (e.g. `write_list: jack`). Files added to the share will be added to the specified group and group write access will be granted by default.

This is an example of configuring multiple vfs object modules to share a glusterfs volume. VFS object options are optional. The necessary VFS object modules must be present/installed outside this role. In this case samba-glusterfs was installed on centos. See samba documentation for how to install or what the default VFS object modules are.

```Yaml
samba_shares:
  - name: gluster-app_deploys
    comment: 'For samba share of volume app_deploys'
    vfs_objects:
      - name: audit
        options:
          - name: facility
            value: LOCAL1
          - name: priority
            value: NOTICE
      - name: glusterfs
        options:
          - name: volume
            value: app_deploys
          - name: logfile
            value: /var/log/samba/glusterfs-app_deploys.%M.log
          - name: loglevel
            value: 7
    path: /
    read_only: no
    guest_ok: yes
    write_list: tomcat
    group: tomcat
```



A complete overview of share options follows below. Only `name` is required, the rest is optional.

| Option                 | Default                         | Comment                                                                                        |
| :---                   | :---                            | :---                                                                                           |
| `comment`              | -                               | A comment string for the share                                                                 |
| `create_mode`          | `0664`                          | See the Samba documentation for details.                                                       |
| `directory_mode`       | `0775`                          | See the Samba documentation for details.                                                       |
| `force_create_mode`    | `0664`                          | See the Samba documentation for details.                                                       |
| `force_directory_mode` | `0775`                          | See the Samba documentation for details.                                                       |
| `group`                | `users`                         | The user group files in the share will be added to.                                            |
| `guest_ok`             | -                               | Allow guest access.                                                                            |
| `name` (required)      | -                               | The name of the share.                                                                         |
| `owner`                | `root`                          | Set the owner of the path                                                                      |
| `path`                 | /{{samba_shares_root}}/{{name}} | The path to the share directory.                                                               |
| `public`               | `no`                            | Controls read access for guest users                                                           |
| `setype`               | `samba_share_t`                 | The SELinux type of the share directory                                                        |
| `valid_users`          | -                               | Controls read access for registered users. Use the syntax of the corresponding Samba setting.  |
| `vfs_objects`          | -                               | See the Samba documentation for details.                                                       |
| `writable`             | -                               | Writable for guests.                                                                           |
| `write_list`           | -                               | Controls write access for registered users. Use the syntax of the corresponding Samba setting. |

The values for `valid_users` and `write_list` should be a comma separated list of users. Names prepended with `+` or `@` are interpreted as groups. The documentation for the [Samba configuration](https://www.samba.org/samba/docs/man/manpages-3/smb.conf.5.html) has more details on these options.

## Dependencies

No dependencies.

## Example Playbook

See the [test playbook](https://github.com/bertvv/ansible-role-samba/blob/docker-tests/test.yml)

## Testing

### Setting up the test environment

Tests for this role are provided in the form of a Vagrant environment that is kept in a separate branch, `tests`. I use [git-worktree(1)](https://git-scm.com/docs/git-worktree) to include the test code into the working directory. Instructions for running the tests:

1. Fetch the tests branch: `git fetch origin tests`
2. Create a Git worktree for the test code: `git worktree add tests tests` (remark: this requires at least Git v2.5.0). This will create a directory `tests/`.
3. `cd tests/`
4. `vagrant up` will then create test VMs for all supported distros and apply a test playbook (`test.yml`) to each one.

### Issues

On Ubuntu 16.04, setting up the VM may fail while running the test playbook because a background process is running the package manager. The output looks like:

```
...
TASK [samba : Install Samba packages] ******************************************
failed: [samba-ubuntu1604] (item=[u'samba-common', u'samba', u'samba-client']) => {"cache_update_time": 0, "cache_updated": false, "failed": true, "item": ["samba-common", "samba", "samba-client"], "msg": "'/usr/bin/apt-get -y -o \"Dpkg::Options::=--force-confdef\" -o \"Dpkg::Options::=--force-confold\"   install 'samba-common' 'samba' 'samba-client'' failed: E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)\nE: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?\n", "stderr": "E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)\nE: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?\n", "stdout": "", "stdout_lines": []}
```

The workaround is waiting a bit and running `vagrant provision` again.

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome. The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork. Github can then easily create a PR based on that branch. Don't forget to add yourself to the list of contributors below!

## License

2-clause BSD license, see [LICENSE.md](LICENSE.md)

## Contributors

[Ben Tomasik](https://github.com/tomislacker)
[Bert Van Vreckem](https://github.com/bertvv/) (maintainer),
[Birgit Croux](https://github.com/birgitcroux),
[DarkStar1973](https://github.com/DarkStar1973),
[Ian Young](https://github.com/iangreenleaf),
[Jonas Heinrich](https://github.com/onny),
[morbidick](https://github.com/morbidick),
[Paul Montero](https://github.com/lpaulmp),
[Slavek Jurkowski](https://github.com/slavekjurkowski2),
[Sven Eeckeman](https://github.com/SvenEeckeman),
[Tomohiko Ozawa](https://github.com/kota65535).
