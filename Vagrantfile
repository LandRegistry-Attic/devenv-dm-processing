# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load configuration file
require 'yaml'
dir = File.dirname(File.expand_path(__FILE__))
conf = YAML.load_file("#{dir}/configuration.yaml")

Vagrant.configure(2) do |node|
  node.vm.box              = "landregistry/centos"
  node.vm.box_check_update = true
  node.ssh.forward_agent = true


  # If applications have ports assigned, let's map these to the host machine
  conf['applications'].each do |app,conf|
    if conf.has_key?('port') && conf['port'] != ''
      port = conf['port'].to_i
      node.vm.network :forwarded_port, guest: port, host: port
    end
  end


  # Run script to configure environment
  node.vm.provision "shell", path: "local/lr-setup-environment"
end
