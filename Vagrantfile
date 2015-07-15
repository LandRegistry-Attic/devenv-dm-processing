# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load configuration file
require 'yaml'
dir = File.dirname(File.expand_path(__FILE__))
conf = YAML.load_file("#{dir}/configuration.yaml")



Vagrant.configure(2) do |node|
  node.vm.box              = "landregistry/centos"
  node.vm.box_version      = "0.1.1"
  node.vm.box_check_update = true
  node.ssh.forward_agent = true

  # Prevent annoying "stdin: is not a tty" errors from displaying during 'vagrant up'
  node.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  if Vagrant::Util::Platform.windows?
      # You MUST have a ~/.ssh/github_rsa (GitHub specific) SSH key to copy to VM
      if File.exists?(File.join(Dir.home, ".ssh", "github_rsa"))
          # Read local machine's GitHub SSH Key (~/.ssh/github_rsa)
          github_ssh_key = File.read(File.join(Dir.home, ".ssh", "github_rsa"))

          # Copy it to VM as the /root/.ssh/github_rsa and to /home/vagrant/.ssh/gitlab_rsa
          node.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local GitHub SSH Key to VM for provisioning...' && mkdir -p /root/.ssh && echo '#{github_ssh_key}' > /root/.ssh/github_rsa && chmod 600 /root/.ssh/github_rsa"
          node.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local GitHub SSH Key to VM for provisioning...' && mkdir -p /home/vagrant/.ssh && echo '#{github_ssh_key}' > /home/vagrant/.ssh/github_rsa && chmod 600 /home/vagrant/.ssh/github_rsa"
          # Change to use port 443 for github
          node.vm.provision :shell, :inline => "echo 'Host github.com \n Hostname ssh.github.com \n StrictHostKeyChecking no \n Port 443' > /home/vagrant/.ssh/config"
          node.vm.provision :shell, :inline => "echo 'Host github.com \n Hostname ssh.github.com \n StrictHostKeyChecking no \n Port 443' > /root/.ssh/config"
      end

      if File.exists?(File.join(Dir.home, ".ssh", "gitlab_rsa"))
          # Read local machine's Gitlab SSH Key
          gitlab_ssh_key = File.read(File.join(Dir.home, ".ssh", "gitlab_rsa"))

          # Copy it to VM as the /root/.ssh/gitlab_rsa and to /home/vagrant/.ssh/gitlab_rsa
          node.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local Gitlab SSH Key to VM for provisioning...' && mkdir -p /root/.ssh && echo '#{gitlab_ssh_key}' > /root/.ssh/gitlab_rsa && chmod 600 /root/.ssh/gitlab_rsa"
          node.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local Gitlab SSH Key to VM for provisioning...' && mkdir -p /home/vagrant/.ssh && echo '#{gitlab_ssh_key}' > /home/vagrant/.ssh/gitlab_rsa && chmod 600 /home/vagrant/.ssh/gitlab_rsa"
          # Change to use port 443 for github
          node.vm.provision :shell, :inline => "echo 'Host git.lr.net \n Hostname git.lr.net \n StrictHostKeyChecking no \n' >> /home/vagrant/.ssh/config"
          node.vm.provision :shell, :inline => "echo 'Host git.lr.net \n Hostname git.lr.net \n StrictHostKeyChecking no \n' >> /root/.ssh/config"
      end
  end

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
