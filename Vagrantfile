# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "750"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--usb", "off"]
  end

  config.vm.network "forwarded_port", guest: 6379, host: 6379, auto_correct: true
  config.vm.box = "ARTACK/debian-jessie"
  config.vm.hostname = "ferengi"

  config.vm.synced_folder "home/share", "/home/share"
  config.vm.synced_folder "root", "/root", owner: "root", group: "root"
  config.vm.synced_folder "home/git", "/home/git"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provision "shell", path: 'provision.sh'
end
