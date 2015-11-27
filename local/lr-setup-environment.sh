#!/usr/bin/env bash

HOME='/home/vagrant'

# Check yo' privledge
# if [ $(id -u) != 0 ]; then
#   echo "You must be root to run $0"
#   exit 1
# fi

if [[ ! $(id vagrant) ]]; then
  echo "You must run $0 inside your Vagrant environment"
  exit 1
fi

# Just for ease of use, let's autoswap to the workspace folder
sed -i -e 's/.*switch to workspace//' ${HOME}/.bash_profile # really hacky idempotency
echo 'cd /vagrant; # switch to workspace' >> ${HOME}/.bash_profile

# We <3 pretty output
sed -i -e 's/.*PS1.*//' ${HOME}/.bash_profile
echo 'export PS1=" \033[1;34mCASEWORK\033[0m \033[1;31m$ \033[0m"' >> ${HOME}/.bash_profile

# Add ./local to PATH
sed -i -e 's/.*add local dir to path//' ${HOME}/.bash_profile
echo 'export PATH=$PATH:/vagrant/local' >> ${HOME}/.bash_profile

# Initially we need to install a load of junk thats not provided by landregistry/centos
echo "- - - Installing system dependencies - - -"
sudo yum install -q -y git GitPython PyYAML python-devel python-pip python-virtualenv python-jinja2 supervisor

# Install Java
cd /opt

echo 'downloading java'
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm"
echo 'java downloaded'

echo 'install java'
yum -y install jdk-8u45-linux-x64.rpm
echo `java -version`

#add helpful aliases
echo "source /vagrant/local/add-aliases.sh" >> ${HOME}/.bash_profile

# Put together a supervisor config
sudo systemctl start supervisord >/dev/null 2>&1
sudo systemctl enable supervisord >/dev/null 2>&1
sudo chown -R vagrant:vagrant /etc/supervisord.d/

# Set up applications
echo "- - - Configuring applications - - -"
sudo -i -u vagrant python /vagrant/local/lr-setup-apps

# Load supervisor config and start applications
echo "- - - Starting services - - -"
sudo supervisorctl reload >/dev/null
