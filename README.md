# Vagrant tests for bertvv.samba

## Setting up the test environment

Tests for this role are provided in the form of a Vagrant environment that is kept in a separate branch, `vagrant-tests`. I use [git-worktree(1)](https://git-scm.com/docs/git-worktree) to include the test code into the working directory. Instructions for running the tests:

1. Fetch the tests branch: `git fetch origin vagrant-tests`
2. Create a Git worktree for the test code: `git worktree add vagrant-tests vagrant-tests` (remark: this requires at least Git v2.5.0). This will create a directory `vagrant-tests/`.
3. `cd vagrant-tests/`
4. `vagrant status` shows a list of the VMs for each of the supported distros
5. `vagrant up` will boot all VMs and apply a test playbook (`test.yml`) to each one. You can of course specify a single VM as well.

### Issues

On Ubuntu 16.04, setting up the VM may fail while running the test playbook because a background process is running the package manager. The output looks like:

```
...
TASK [samba : Install Samba packages] ******************************************
failed: [samba-ubuntu1604] (item=[u'samba-common', u'samba', u'samba-client']) => {"cache_update_time": 0, "cache_updated": false, "failed": true, "item": ["samba-common", "samba", "samba-client"], "msg": "'/usr/bin/apt-get -y -o \"Dpkg::Options::=--force-confdef\" -o \"Dpkg::Options::=--force-confold\"   install 'samba-common' 'samba' 'samba-client'' failed: E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)\nE: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?\n", "stderr": "E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)\nE: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?\n", "stdout": "", "stdout_lines": []}
```

The workaround is waiting a bit and running `vagrant provision` again.


