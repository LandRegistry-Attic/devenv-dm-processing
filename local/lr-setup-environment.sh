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

# install dependencies not provided by landregistry/centos
echo "- - - Installing system dependencies - - -"
yum install -q -y gcc gcc-c++ supervisor python-jinja2 PyYAML git GitPython

echo "Installing Python 3.4"
yum -y install python34 python34-devel

echo "Installing python pip"
yum -y install python-pip
pip install --upgrade pip

echo "Installing virtualenvwrapper"
pip install --upgrade virtualenv
pip install virtualenvwrapper
source /usr/bin/virtualenvwrapper.sh
echo "source /usr/bin/virtualenvwrapper.sh" >> ${HOME}/.bash_profile
echo "export WORKON_HOME=/home/vagrant/.venv/" >>  ${HOME}/.bash_profile

# download get-pip.py (also used in lr-setup-apps when setting up python apps)
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.4 get-pip.py

echo "Installing killall command tool"
yum install -y psmisc

#for phantomjs
sudo yum -y update
sudo yum -y install libXext  libXrender  fontconfig  libfontconfig.so.1
# Install Java
if type -p java; then
    echo 'Java already installed.  Destroy VM to re-install.'
else
    cd /opt
    echo 'downloading java'
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm" >/dev/null 2>&1
    echo 'java downloaded'
    echo 'install java'
    yum -y install jdk-8u45-linux-x64.rpm
    echo `java -version`
fi

#install phantomjs
echo "- - - installing phantomjs - - -"
cd ~
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
mv $PHANTOM_JS.tar.bz2 /usr/local/share/
cd /usr/local/share/
tar xvjf $PHANTOM_JS.tar.bz2
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs

if type -p gradle; then
    echo 'gradle already installed.  Destroy VM to re-install.'
else
    # installs to /opt/gradle
    # existing versions are not overwritten/deleted
    # seamless upgrades/downgrades
    # $GRADLE_HOME points to latest *installed* (not released)
    gradle_version=2.3
    mkdir /opt/gradle
    wget -N http://services.gradle.org/distributions/gradle-${gradle_version}-all.zip >/dev/null 2>&1
    unzip -oq ./gradle-${gradle_version}-all.zip -d /opt/gradle
    ln -sfnv gradle-${gradle_version} /opt/gradle/latest
    printf "export GRADLE_HOME=/opt/gradle/latest\nexport PATH=\$PATH:\$GRADLE_HOME/bin" > /etc/profile.d/gradle.sh
    . /etc/profile.d/gradle.sh
    hash -r ; sync
    # check installation
    gradle -v
fi

sudo -i -u vagrant source install_rvm.sh

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
