devenv-dm-processing
===============

Early development environment for the Digital Mortgage project.

## About

Development environment intended to closely mirror the final server environment.

Requirements:
 - Vagrant < 1.4


## How to use

Inside the project folder, simply run `vagrant up`, then 'vagrant ssh' and then connect to your projects on the ports defined in `configuration.yaml`


## Useful commands

All the apps are run by supervisord, here are some helpful aliases for supervisorctl.
```
status                - view running status of all apps (via supervisorctl)
stop {name of app}    - stop app running in supervisord
start {name of app}   - start app running in supervisord
restart {name of app} - restart app running in supervisord
reload                - reload supervisord config and restart all apps
startsup              - start supervisord (needed after a vagrant halt/vagrant up)
```

To run the app in the terminal (i.e. not via supervisord, so you can directly see the output)
```
lr-run {name of app}
```


## Apps

These are held in a private repository at the moment.


## Notes
The development environment relies on [Vagrant](https://www.vagrantup.com/).
Currently only Virtualbox is supported as a provider.

For further information on managing Vagrant you can read the [official documentation](https://docs.vagrantup.com/v2/).

TIP: You can improve the start-up time of the development environment by installing the [cachier](https://github.com/fgrehm/vagrant-cachier) Vagrant plugin.

You can install it by running:
```bash
$ vagrant plugin install vagrant-cachier
```




