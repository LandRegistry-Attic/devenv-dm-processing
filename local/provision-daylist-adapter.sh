echo "Installing RVM..."
curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \curl -sSL https://get.rvm.io | bash -s -- --version 1.26.10
source "/home/vagrant/.rvm/scripts/rvm"
echo "Gems will install without docs for this environment"
echo "gem: --no-rdoc --no-ri" > ~/.gemrc

echo "Enabling gem globalcache..."
rvm gemset globalcache enable

echo "Installing JRuby..."
rvm install jruby-1.7.19
