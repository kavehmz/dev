# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "750"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--usb", "off"]
  end

  config.vm.box = "debian/contrib-jessie64"
  config.vm.hostname = "ferengi"

  config.vm.synced_folder "home/share", "/home/share"
  config.vm.synced_folder "root", "/root", owner: "root", group: "root"
  config.vm.synced_folder "home/projects/src/github.com/kavehmz", "/home/projects/src/github.com/kavehmz"
  if ENV['PRIVATE_GITLAB'] != ''
    config.vm.synced_folder "home/projects/src/#{ENV['PRIVATE_GITLAB']}", "/home/projects/src/#{ENV['PRIVATE_GITLAB']}"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provision "shell", path: 'provision.sh'
end
