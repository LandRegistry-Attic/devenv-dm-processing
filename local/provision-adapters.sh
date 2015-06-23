echo "- - - Installing RVM - - -"
curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \curl -sSL https://get.rvm.io | bash -s stable
source "/home/vagrant/.rvm/scripts/rvm"
echo "- - - Gems will install without docs for this environment - - -"
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

echo "- - - Enabling gem globalcache..."
rvm gemset globalcache enable

echo "- - - Installing JRuby..."
rvm install jruby-1.7.19

echo "- - - Installing Ruby - - -"
rvm install ruby-1.9.3

echo "- - - Give Vagrant ownership of RVM and Gem directories - - -"
sudo chown -R vagrant /home/vagrant/.rvm
sudo chown -R vagrant /home/vagrant/.gem

echo "- - - Installing Bundler in JRuby - - -"
rvm use jruby-1.7.19
gem install bundler

echo "- - - Installing Bundler in Ruby - - -"
rvm use ruby-1.9.3
gem install bundler

echo "- - - Switch back to JRuby - - -"
rvm use jruby-1.7.19

echo "- - - Attempting to setup Daylist Adapter - - -"
cd /vagrant/apps/
if [ ! -d /vagrant/apps/daylist-adapter/ ];
then (git clone git@git.lr.net:casework/daylist-adapter.git && cd /vagrant/apps/daylist-adapter/ && bundle install && torquebox deploy && echo "- - - Successfully setup Daylist Adapter - - -") || echo "- - - Can't install daylist adapter off-DITI - --"
else cd /vagrant/apps/daylist-adapter/ && bundle install && torquebox deploy && echo "- - - Successfully setup Daylist Adapter - - -"
fi

echo "- - - Attempting to setup Titles Adapter - - -"
cd /vagrant/apps/
if [ ! -d /vagrant/apps/titles-adapter/ ];
then (git clone git@git.lr.net:casework/titles-adapter.git && cd /vagrant/apps/titles-adapter/ && bundle install && torquebox deploy && echo "- - - Successfully setup Titles Adapter - - -") || echo "- - - Can't install titles adapter off-DITI - --"
else cd /vagrant/apps/titles-adapter/ && bundle install && torquebox deploy && echo "- - - Successfully setup Titles Adapter - - -"
fi
