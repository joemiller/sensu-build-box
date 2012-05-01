# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant::Config.run do |config|
  config.vm.box = 'ubuntu_1204_64'
  config.vm.box_url = 'http://vagrant.sensuapp.org/ubuntu-1204-amd64.box'
  # convert underscores in hostname to '-' so ubuntu 10.04's hostname(1)
  # doesn't freak out on us.
  hostname = "sensu-build1"
  config.vm.customize ['modifyvm', :id, '--memory', '640']
  config.vm.customize ['modifyvm', :id, '--cpus', '2']

  config.vm.forward_port 8080, 8080
  config.vm.forward_port 80, 10080
  config.vm.forward_port 443, 10443

  config.vm.provision :shell, :inline => "gem install chef --no-rdoc --no-ri"
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.data_bags_path = "chef/data_bags"
    chef.roles_path = "chef/roles"
    chef.add_role("sensu_build_box")
  end
end

