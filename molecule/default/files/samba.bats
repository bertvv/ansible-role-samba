#! /usr/bin/env bats
#
# Author:   Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Test a Samba server

sut_wins_name=SAMBA_TEST    # NetBIOS name
workgroup=TESTGROUP # Workgroup

# The name of a directory and file that will be created to test for
# write access (= random string)
test_dir=peghawJaup
test_file=Nocideicye

# {{{Helper functions

# Checks if a user has shell access to the system
# Usage: assert_can_login USER PASSWD
assert_can_login() {
  echo $2 | su -c 'ls ${HOME}' - $1
}

# Checks that a user has NO shell access to the system
# Usage: assert_cannot_login USER
assert_cannot_login() {
  run sudo su -c 'ls' - $1
  [ "0" -ne "${status}" ]
}

# Check that the guest account has read access
# Usage: assert_guest_read SHARE
assert_guest_read() {
  local share="${1}"

  run smbclient "//${SUT_IP}/${share}" \
    --user=% \
    --command='ls'

  echo "${output}"

  [ "${status}" -eq "0" ]
}

# Check that a user has read acces to a share
# Usage: read_access SHARE USER PASSWORD
assert_read_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${SUT_IP}/${share}" \
    --user=${user}%${password} \
    --command='ls'

  echo "${output}"

  [ "${status}" -eq "0" ]
}

# Check that a user has NO read access to a share
# Usage: no_read_access SHARE USER PASSWORD
assert_no_read_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${SUT_IP}/${share}" \
    --user=${user}%${password} \
    --command='ls'

  echo "${output}"

  [ "${status}" -eq "1" ]
}

# Check that a user has write access to a share
# Usage: write_access SHARE USER PASSWORD
assert_write_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${SUT_IP}/${share}" \
    --user=${user}%${password} \
    --command="mkdir ${test_dir};rmdir ${test_dir}"

  echo "${output}"

  # Output should NOT contain any error message. Checking on exit status is
  # not reliable, it can be 0 when the command failed...
  [ -z "$(echo ${output} | grep NT_STATUS_)" ]
}

# Check that a user has NO write access to a share
# Usage: no_write_access SHARE USER PASSWORD
assert_no_write_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${SUT_IP}/${share}" \
    --user=${user}%${password} \
    --command="mkdir ${test_dir};rmdir ${test_dir}"

  echo "${output}"

  # Output should contain an error message (beginning with NT_STATUS, usually
  # NT_STATUS_MEDIA_WRITE_PROTECTED
  [ -n "$(echo ${output} | grep NT_STATUS_)" ]
}

# Check that users from the same group can write to each other’s files
# Usage: assert_group_write_file SHARE USER1 PASSWD1 USER2 PASSWD2
assert_group_write_file() {
  local share="${1}"
  local user1="${2}"
  local passwd1="${3}"
  local user2="${4}"
  local passwd2="${5}"

  echo "Hello world!" > ${test_file}

  smbclient "//${SUT_IP}/${share}" --user=${user1}%${passwd1} \
    --command="put ${test_file}"
  # In order to overwrite the file, write access is needed. This will fail
  # if user2 doesn’t have write access.
  smbclient "//${SUT_IP}/${share}" --user=${user2}%${passwd2} \
    --command="put ${test_file}"
}

# Check that users from the same group can write to each other’s directories
# Usage: assert_group_write_dir SHARE USER1 PASSWD1 USER2 PASSWD2
assert_group_write_dir() {
  local share="${1}"
  local user1="${2}"
  local passwd1="${3}"
  local user2="${4}"
  local passwd2="${5}"

  smbclient "//${SUT_IP}/${share}" --user=${user1}%${passwd1} \
    --command="mkdir ${test_dir}; mkdir ${test_dir}/tst"
  run smbclient "//${SUT_IP}/${share}" --user=${user2}%${passwd2} \
    --command="rmdir ${test_dir}/tst"
  [ -z $(echo "${output}" | grep NT_STATUS_ACCESS_DENIED) ]
}

#}}}

@test 'NetBIOS name resolution should work' {
  #skip
  # Look up the Samba server’s NetBIOS name under the specified workgroup
  # The result should contain the IP followed by NetBIOS name
  nmblookup -U ${SUT_IP} --workgroup ${workgroup} ${sut_wins_name} | grep "^${SUT_IP} ${sut_wins_name}"
}

# Read / write access to shares

@test 'read access for share ‘restrictedshare’' {
  #                      Share            User  Password
  assert_read_access     restrictedshare  usr1  usr1
  assert_read_access     restrictedshare  usr2  usr2
}

@test 'write access for share ‘restrictedshare’' {
  #                      Share            User  Password
  assert_no_write_access restrictedshare  usr1  usr1
  assert_no_write_access restrictedshare  usr2  usr2
}

@test 'read access for share ‘privateshare’' {
  #                      Share            User  Password
  assert_read_access     privateshare  usr1  usr1
  assert_no_read_access  privateshare  usr2  usr2
}

@test 'write access for share ‘privateshare’' {
  #                      Share            User  Password
  assert_write_access    privateshare  usr1  usr1
  assert_no_write_access privateshare  usr2  usr2
}

@test 'read access for share ‘protectedshare’' {
  #                      Share            User  Password
  assert_read_access     protectedshare  usr1  usr1
  assert_read_access     protectedshare  usr2  usr2
}

@test 'write access for share ‘protectedshare’' {
  #                      Share            User  Password
  assert_no_write_access protectedshare  usr1  usr1
  assert_write_access    protectedshare  usr2  usr2
}
 
@test 'read access for share ‘publicshare’' {
  #                      Share            User  Password
  assert_read_access     publicshare  usr1  usr1
  assert_read_access     publicshare  usr2  usr2
}

@test 'write access for share ‘publicshare’' {
  #                      Share            User  Password
  assert_write_access    publicshare  usr1  usr1
  assert_write_access    publicshare  usr2  usr2
}

@test 'Guest access in share ‘guestshare’' {
  assert_guest_read guestshare
}
