echo "- - - Installing RVM - - -"
curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \curl -sSL https://get.rvm.io | bash -s stable
source "/home/vagrant/.rvm/scripts/rvm"
echo "- - - Gems will install without docs for this environment - - -"
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

echo "- - - Enabling gem globalcache..."
rvm gemset globalcache enable

echo "- - - Installing JRuby..."
rvm install jruby-1.7.19

echo "- - - Give Vagrant ownership of RVM and Gem directories - - -"
sudo chown -R vagrant /home/vagrant/.rvm
sudo chown -R vagrant /home/vagrant/.gem

echo "- - - Attempting to setup Daylist Adapter - - -"
cd /vagrant/apps/
if [ ! -d /vagrant/apps/daylist-adapter/ ];
then (git clone git@git.lr.net:casework/daylist-adapter.git && cd /vagrant/apps/daylist-adapter/ && bundle install && torquebox deploy && echo "- - - Successfully setup Daylist Adapter - - -") || echo "- - - Can't install adapters off DITI - --"
fi
