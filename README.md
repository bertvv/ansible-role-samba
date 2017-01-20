# Docker test environment

This branch contains a test environment for the samba role, powered by Docker. It can be used to either run tests locally, or remotely on [Travis-CI](https://travis-ci.org/).  [git-worktree(1)](https://git-scm.com/docs/git-worktree) is used to include the test code into the working directory. Remark that this requires at least Git v2.5.0.

1. Fetch the test branch: `git fetch origin docker-tests`
2. Create a Git worktree for the test code: `git worktree add docker-tests docker-tests`. This will create a directory `docker-tests/`
3. The script `docker-tests.sh` will create a Docker container, and apply this role from a playbook `<test.yml>`. The Docker images are configured for testing Ansible roles and are published at <https://hub.docker.com/r/bertvv/ansible-testing/>. There are images available for several distributions and versions. The distribution and version should be specified outside the script using environment variables:

    ```
    DISTRIBUTION=centos VERSION=7 ./docker-tests/docker-tests.sh
    ```

    The specific combinations of distributions and versions that are supported by this role are specified in `.travis.yml`.


