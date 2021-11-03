# -*- coding: utf-8 -*-
# :Project:   endian.firewalld ansible role - unittests
# :Created:   Tue 11 May 2021 22:05:46 CEST
# :Author:    Peter Warasin <peter@endian.com>
# :License:   GPLv2
# :Copyright: © 2021 Endian s.r.l.
#


"""
test_default.py - default unittest file.

This file contains unittests using testinfra used to test if the
ansible role does what we wanted that it would do.
"""


def test_share_directory(host):
    """
    Test if the cron script is installed correctly.

    This test method checks if the cron script is copied
    correctly to the test system.

    :param host:     the link to the testinfra host provided by fixture
    :type  host:     Host object
    """
    file1 = host.file("/data/testshare")
    assert file1.is_directory
    assert file1.user == "testuser"
    assert file1.group == "testgroup"
    assert file1.mode == 0o775


def test_facl_on_directory(host):
    """
    Test if the testshare directory has the correct facl settings

    :param host:     the link to the testinfra host provided by fixture
    :type  host:     Host object
    """
    file1 = None
    try:
        file1 = host.ansible(
            "command",
            "getfacl /data/testshare",
            check=False,
        )
    except host.ansible.AnsibleException as exc:
        assert exc.result["failed"] is True
        assert exc.result["msg"] == ""
        return None

    assert file1["stdout_lines"][0] == '# file: data/testshare'
    assert file1["stdout_lines"][1] == '# owner: testuser'
    assert file1["stdout_lines"][2] == '# group: testgroup'
    assert file1["stdout_lines"][3] == 'user::rwx'
    assert file1["stdout_lines"][4] == 'group::rwx'
    assert file1["stdout_lines"][5] == 'other::r-x'
    assert file1["stdout_lines"][7] == 'default:user:testuser2:rwx'
    assert file1["stdout_lines"][9] == 'default:group:testgroup:rwx'
