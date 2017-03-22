## System Plays

These plays mostly take care of installing and configuring things initially.

### Install General

Installs a bunch of convenience scripts and useful binaries like git for which its not hard to imagine that every server would want to run. If there's something missing, feel free to add it. Also has a bunch of useful ansible role depencencies like:

* Cockpit
* Docker

### Install Web

Installs some more convenience scripts and binaries which are specific to the web server assembly. Also takes responsibility for starting docker using docker-compose, which in turn kicks off several more build pipelines. Depends on Install General. Finally it also installs several cron tasks which need to be running like pausing on-demand containers.

### Configure Web

A lot of configuration needs to live in certain places which aren't accessable until after docker-compose has been run. This play takes responsibility for installing those configuration files into the right place after docker-compose has run.

## Configure-backups

Has no dependencies. Can be run against any host to automagically add backups. See docs/configure-backups.md.

### REQUIREMENTS

Take note of the first requirement in install-web.yml: marvinpinto.docker. At the moment, docker 1.12 (?) has a bug in Ubuntu which prevents docker from linking containers with dots in their name. When the package maintainers update docker in the apt repositories we can remove this requirement and install normally using apt-get in the install-general role.