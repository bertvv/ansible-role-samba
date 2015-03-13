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

