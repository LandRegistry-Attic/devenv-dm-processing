dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
	echo "Looking for RVM install..."
	source "$HOME/.rvm/scripts/rvm"
else
	echo "RVM not found, installing..."
	curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \curl -sSL https://get.rvm.io | bash -s -- --version 1.26.10
	source "$HOME/.rvm/scripts/rvm"
	if [ -n "$DEPLOY_ENVIRONMENT" ]; then
	    echo "Gems will install without docs for this environment"
	    echo "gem: --no-rdoc --no-ri" > ~/.gemrc
	fi
fi

echo "Enabling gem globalcache..."
rvm gemset globalcache enable

echo "Installing JRuby..."
rvm install ruby-2.2.1

echo "Turning off Gemfile warning..."
rvm rvmrc warning ignore $dir/Gemfile

cd $dir

echo "Installing gem bundle..."
bundle install