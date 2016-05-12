# vi: ft=ruby

VAGRANTFILE_API_VERSION = '2'
ROLE_NAME = 'samba'

hosts = [
  { maintainer: 'geerlingguy', distro: 'ubuntu1404', ip: '192.168.56.21' },
  { maintainer: 'geerlingguy', distro: 'ubuntu1604', ip: '192.168.56.22' },
  { maintainer: 'geerlingguy', distro: 'centos6',    ip: '192.168.56.23' },
  { maintainer: 'bertvv',      distro: 'centos71',   ip: '192.168.56.24' },
  { maintainer: 'bertvv',      distro: 'centos72',   ip: '192.168.56.25' },
  { maintainer: 'bertvv',      distro: 'fedora23',   ip: '192.168.56.26' }
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
