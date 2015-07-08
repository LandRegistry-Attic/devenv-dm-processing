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

To quickly view the logs of an app
```
lr-log {name of app}
```

## Apps
### [Cases API:](https://github.com/LandRegistry/cases-api)

`localhost:5001`
- **GET POST** `/cases`
- **GET** `/cases/<caseid>`

### [Cases Frontend:](https://github.com/LandRegistry/cases-frontend)

`localhost:5002`
- `/cases`
- `/cases/<casenumber>`

### [Register Metadata](https://github.com/LandRegistry/register-metadata)

`localhost:5003`
- **GET** `/mdref/<md_ref>`

### [Update Register](https://github.com/LandRegistry/update-register)

`localhost:5004`
- **POST** `/titles` - Add whole working register.
- **GET** `/titles/<title_number>` - Get whole working register.
- **POST** `/titles/<title_number>/groups/<group_position>/entries/<entry_position>` - Amend an individual entry.
- **PUT** `/titles/<title_number>/groups/<group_position>/entries/` - Insert an entry.
- **DELETE** `/titles/<title_number>/groups/<group_position>/entries/<entry_position>` - Delete an entry.
- **GET** `/entrystructure/` - Get entry structure.
- **PUT** `/titles/<title_number>/groups` - Insert a group.
- **DELETE** `/titles/<title_number>/groups/<group_position>` - Delete a group.
- **POST** `/titles/<title_number>/groups/<group_position>` - Amend a group.

### [Titles API:](https://github.com/LandRegistry/titles-api)

`localhost:5005`
- **GET** `/validate/<title_number>`

### [Auto Process Charge](https://github.com/LandRegistry/auto-process-charge)

`localhost:5006`
- **POST** `/process/`

### [Daylist Adapter:](http://git.lr.net/casework/daylist-adapter)

`localhost:8888/DaylistAdapter`
- **POST** `/cases/<title_number>`

### [Titles Adapter:](http://git.lr.net/casework/titles-adapter)

`localhost:8888/TitlesAdapter`
- **POST** `/titles/<title_number>`

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
