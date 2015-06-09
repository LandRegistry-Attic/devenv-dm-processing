yum install -y git

yum install -y java-1.7.0-openjdk-devel

wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

yum install -y apache-maven

echo "Installing RVM..."
curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \curl -sSL https://get.rvm.io | bash -s -- --version 1.26.10
source "/home/vagrant/.rvm/scripts/rvm"
echo "Gems will install without docs for this environment"
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

echo "Enabling gem globalcache..."
rvm gemset globalcache enable

echo "Installing JRuby..."
rvm install jruby-1.7.19

cd /vagrant

bundle install
