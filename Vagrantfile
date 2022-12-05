# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
# vagrant version 2.0.1
# Virtual Box Version 5.2.42
Vagrant.configure("2") do |config|
  config.vm.box = "2kish/ubuntu-docker"
  config.vm.box_version = "1.0"
  config.vm.post_up_message = "Box is ready for usage."
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false  
  end
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  # vagrant plugin install vagrant-docker-compose
 # config.vagrant.plugins = "vagrant-docker-compose"
 # config.vm.provision :docker
 # config.vm.provision :docker_compose
  #config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.provision "shell" do |s|
    s.inline = "rm -rf /vagrant && sudo mkdir /vagrant && \
    chmod -R 777 /vagrant && chown vagrant:vagrant /vagrant"
  end
  config.vm.provision "file", source: "./", destination: "/vagrant"  
  
#  config.vm.synced_folder "./mage2kishbox", "/vagrant/mage2kishbox", :mount_options => ["dmode=777", "fmode=666"]
#  config.vm.provision "shell", inline: <<-SHELL
	#chmod -R 777 /var/www
#  SHELL
#  config.vm.provision "file", source: "./var/www/server/www/.", destination: "/var/www/server/www"
#  config.vm.provision "file", source: "./var/www/server/data/.", destination: "/var/www/server/data"
# https://cestmonvoyage.wordpress.com/2015/12/22/installing-vagrant-virtualbox/
# vagrant plugin install vagrant-disksize
#  config.disksize.size = '50GB'
  config.vm.provider "virtualbox" do |vb|
     vb.memory = "6144"
   end
  config.vm.provision :shell, path: "./bootstrap.sh", run: 'always'   

end
