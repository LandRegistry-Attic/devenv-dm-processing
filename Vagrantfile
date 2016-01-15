# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load configuration file
require 'yaml'
dir = File.dirname(File.expand_path(__FILE__))
conf = YAML.load_file("#{dir}/configuration.yaml")



Vagrant.configure(2) do |node|
  node.vm.box              = "landregistry/centos"
  node.vm.box_version      = "0.3.0"
  node.vm.box_check_update = true
  node.ssh.forward_agent = true
  # node.ssh.pty = false

  # Prevent annoying "stdin: is not a tty" errors from displaying during 'vagrant up'
  node.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  if Vagrant::Util::Platform.windows?
      # You MUST have a ~/.ssh/github_rsa (GitHub specific) SSH key to copy to VM
      if File.exists?(File.join(Dir.home, ".ssh", "github_rsa"))
          # Read local machine's GitHub SSH Key (~/.ssh/github_rsa)
          github_ssh_key = File.read(File.join(Dir.home, ".ssh", "github_rsa"))

          # Copy it to VM as the /root/.ssh/github_rsa and to /home/vagrant/.ssh/gitlab_rsa
          node.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local GitHub SSH Key to VM for provisioning...' && mkdir -p /home/vagrant/.ssh && echo '#{github_ssh_key}' > /home/vagrant/.ssh/github_rsa && chmod 600 /home/vagrant/.ssh/github_rsa && chown vagrant:vagrant -R /home/vagrant/.ssh/"
          # Change to use port 443 for github
          node.vm.provision :shell, :inline => "echo 'Host github.com \n Hostname ssh.github.com \n StrictHostKeyChecking no \n Port 443 \n IdentityFile /home/vagrant/.ssh/github_rsa' > /home/vagrant/.ssh/config"
      end

      if File.exists?(File.join(Dir.home, ".ssh", "gitlab_rsa"))
          # Read local machine's Gitlab SSH Key
          gitlab_ssh_key = File.read(File.join(Dir.home, ".ssh", "gitlab_rsa"))

          # Copy it to /home/vagrant/.ssh/gitlab_rsa
          node.vm.provision :shell, :inline => "echo 'Windows-specific: Copying local Gitlab SSH Key to VM for provisioning...' && mkdir -p /home/vagrant/.ssh && echo '#{gitlab_ssh_key}' > /home/vagrant/.ssh/gitlab_rsa && chmod 600 /home/vagrant/.ssh/gitlab_rsa && chown vagrant:vagrant -R /home/vagrant/.ssh/"
          node.vm.provision :shell, :inline => "echo 'Host git.lr.net \n Hostname git.lr.net \n StrictHostKeyChecking no \n IdentityFile /home/vagrant/.ssh/gitlab_rsa' >> /home/vagrant/.ssh/config"
      end
  end

  # If applications have ports assigned, let's map these to the host machine
  conf['applications'].each do |app,conf|
    if conf.has_key?('port') && conf['port'] != ''
      port = conf['port'].to_i
      node.vm.network :forwarded_port, guest: port, host: port
    end

    node.vm.network :forwarded_port, guest: 5432, host: 15432
  end

  # Run scripts to configure environment
  node.vm.provision :shell, :inline => "source /vagrant/local/lr-setup-environment.sh"

  node.vm.provider :virtualbox do |vb|
    vb.name = "devenv-dm-processing"
    vb.customize ['modifyvm', :id, '--memory', ENV['VM_MEMORY'] || 4096]
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ["modifyvm", :id, "--cpus", ENV['VM_CPUS'] || 4]
  end
end
