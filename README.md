devenv-casework
===============

Early development environment for the Digital by Default Casework project

## Development

The development environment relies on [Vagrant](https://www.vagrantup.com/).
Currently only Virtualbox is supported as a provider.

You can start up the environment by running `vagrant up` inside the project folder.
For further information on managing Vagrant you can read the [official documentation](https://docs.vagrantup.com/v2/).

## Notes

TIP: You can improve the start-up time of the development environment by installing the [cachier](https://github.com/fgrehm/vagrant-cachier) Vagrant plugin.

You can install it by running:
```bash
$ vagrant plugin install vagrant-cachier
```