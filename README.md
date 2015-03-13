# Ansible role `bertvv.samba`

An Ansible role for setting up Samba as a file server. Specifically, the responsibilities of this role are to:

- Install the necessary packages
- Configure SELinux settings
- Create share directories
- Manage users and passwords
- Manage access to shares

## Requirements

SELinux is expected to be running and the firewall should be active.

## Role Variables


| Variable   | Required | Default | Comments (type)  |
| :---       | :---     | :---    | :---             |
| `role_var` | no       | -       | (scalar) PURPOSE |

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

