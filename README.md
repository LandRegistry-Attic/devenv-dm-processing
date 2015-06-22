devenv-casework
===============

Early development environment for the Digital by Default Casework project.

## About

This development environment is designed to be easy to use, and function very similarly to a server environment.

Requirements:
 - Vagrant < 1.4
 - Virtualbox < 4.3.20


## TL;DR

Inside the project folder, simply run `vagrant up` and then connect to your projects on the ports defined in `configuration.yaml`

## Apps
### [Cases API:](https://github.com/LandRegistry/cases-api)

`localhost:5001`
- **GET POST** `/cases`
- **GET** `/cases/<caseid>`

### [Cases Frontend:](https://github.com/LandRegistry/cases-frontend)

`localhost:5002`
- `/cases`
- `/cases/<casenumber>`

### [Titles API:](https://github.com/LandRegistry/titles-api)

`localhost:5005`
- **GET** `/validate/<titlenumber>`

### [Daylist Adapter:](http://git.lr.net/casework/daylist-adapter)

`localhost:8888/DaylistAdapter`
- **POST** `/cases/<titlenumber>`

### [Titles Adapter:](http://git.lr.net/casework/titles-adapter)

`localhost:8888/TitlesAdapter`
- **POST** `/titles/<titlenumber>`


## Notes
The development environment relies on [Vagrant](https://www.vagrantup.com/).
Currently only Virtualbox is supported as a provider.

For further information on managing Vagrant you can read the [official documentation](https://docs.vagrantup.com/v2/).

TIP: You can improve the start-up time of the development environment by installing the [cachier](https://github.com/fgrehm/vagrant-cachier) Vagrant plugin.

You can install it by running:
```bash
$ vagrant plugin install vagrant-cachier
```

##How to query the postgres database with PSQL

Login to the centos virtual machine.  Switch to root with:

```
sudo -i
```

login to the system of record database with this:

```
psql -U workingregister workingregister
```
