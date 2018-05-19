# vi: ft=ruby

VAGRANTFILE_API_VERSION = '2'
ROLE_NAME = 'samba'

hosts = [
  { maintainer: 'bento', distro: 'debian-9.4',   ip: '192.168.56.10' },
  { maintainer: 'bento', distro: 'ubuntu-16.04', ip: '192.168.56.15' },
  { maintainer: 'bento', distro: 'ubuntu-18.04', ip: '192.168.56.16' },
  { maintainer: 'bento', distro: 'centos-6.9',   ip: '192.168.56.20' },
  { maintainer: 'bento', distro: 'centos-7.4',   ip: '192.168.56.21' },
  { maintainer: 'bento', distro: 'fedora-27',    ip: '192.168.56.25' }
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  hosts.each do |host|
    host_name = ROLE_NAME + '-' + host[:distro]

    config.vm.define host_name do |node|
      node.vm.box = host[:maintainer] + '/' + host[:distro]
      node.vm.hostname = host_name
      node.vm.network :private_network, ip: host[:ip]
    end
  end
  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'test.yml'
  end
end
