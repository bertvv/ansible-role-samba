# Ansible role `bertvv.samba`

An Ansible role for setting up Samba as a file server. Specifically, the responsibilities of this role are to:

- Install the necessary packages
- Configure SELinux settings
- Create share directories
- Manage users and passwords
- Manage access to shares

## Requirements

- SELinux is expected to be running
- The firewall should be active
- Samba users should already exist as system users

You can take a look at role [bertvv.el7](https://galaxy.ansible.com/list#/roles/2305) that does all this and more.

## Role Variables


| Variable                       | Required | Default         | Comments                                                                          |
| :---                           | :---     | :---            | :---                                                                              |
| `samba_create_varwww_symlinks` | no       | -               | When this is set to `yes`, symlinks are created in `/var/www/html` to the shares. |
| `samba_load_homes`             | no       | no              | Make user home directories accessible.                                            |
| `samba_load_printers`          | no       | no              | Make printers accessible.                                                         |
| `samba_log`                    | no       | -               | Set the log file. If left undefined, logging is done through syslog.              |
| `samba_log_size`               | no       | 5000            | Set the maximum size of the log file.                                             |
| `samba_map_to_guest`           | no       | `bad user`      | Behaviour when unregistered users access the shares.                              |
| `samba_netbios_name`           | yes      | -               | The NetBIOS name of this server.                                                  |
| `samba_passdb_backend`         | no       | `tdbsam`        | Password database backend.                                                        |
| `samba_security`               | no       | `user`          | Samba security setting                                                            |
| `samba_server_string`          | no       | `fileserver %m` | Comment string for the server.                                                    |
| `samba_shares`                 | no       | -               | List of dicts containing share definitions. See below for details.                |
| `samba_shares_root`            | no       | `/srv/shares`   | Directories for the shares are created under this directory.                      |
| `samba_users`                  | no       | -               | List of dicts defining users that can access shares.                              |
| `samba_workgroup`              | no       | `WORKGROUP`     | Name of the server workgroup.                                                     |

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

Unfortunately, passwords have to be in plain text for now.

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

A complete overview of share options follows below. Only `name` is required, the rest is optional.

| Option                 | Default | Comment                                                                                        |
| :---                   | :---    | :---                                                                                           |
| `name`                 | -       | The name of the share.                                                                         |
| `comment`              | -       | A comment string for the share                                                                 |
| `public`               | `no`    | Controls read access for guest users                                                           |
| `valid_users`          | -       | Controls read access for registered users. Use the syntax of the corresponding Samba setting.  |
| `write_list`           | -       | Controls write access for registered users. Use the syntax of the corresponding Samba setting. |
| `group`                | `users` | The user group files in the share will be added to.                                            |
| `create_mask`          | `0664`  | See the Samba documentation for details.                                                       |
| `create_mode`          | `0664`  | See the Samba documentation for details.                                                       |
| `force_create_mode`    | `0664`  | See the Samba documentation for details.                                                       |
| `directory_mask`       | `0775`  | See the Samba documentation for details.                                                       |
| `directory_mode`       | `0775`  | See the Samba documentation for details.                                                       |
| `force_directory_mode` | `0775`  | See the Samba documentation for details.                                                       |

The values for `valid_users` and `write_list` should be a comma separated list of users. Names prepended with `+` or `@` are interpreted as groups. The documentation for the [Samba configuration](https://www.samba.org/samba/docs/man/manpages-3/smb.conf.5.html) has more details on these options.

## Dependencies

No dependencies.

## Example Playbook

See the [test playbook](tests/test.yml)

## Testing

The `tests` directory contains acceptance tests for this role in the form of a Vagrant environment. The directory `tests/roles/samba` is a symbolic link that should point to the root of this project in order to work. To create it, do

```ShellSession
$ cd tests/
$ mkdir roles
$ ln -frs ../../PROJECT_DIR roles/samba
```

You may want to change the base box into one that you like. The current one is based on Box-Cutter's [CentOS Packer template](https://github.com/boxcutter/centos).

The playbook [`test.yml`](tests/test.yml) applies the role to a VM, setting role variables.

## See also

If you are looking for a Samba role for Debian or Ubuntu, take a look at this [comprehensive role](https://galaxy.ansible.com/list#/roles/1597) by Debops. Jeff Geerling also has written a [Samba role for EL](https://galaxy.ansible.com/list#/roles/438), but at the time of writing this, it is very basic.

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section. Pull requests are also very welcome. Preferably, create a topic branch and when submitting, squash your commits into one (with a descriptive message).

## License

BSD

## Author Information

Bert Van Vreckem (bert.vanvreckem@gmail.com)

