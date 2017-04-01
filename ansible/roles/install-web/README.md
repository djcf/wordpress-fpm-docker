install-web
=========

A specific ansible install role for webhosts. This role sets up the system *before* docker is run. Finally, it runs docker. Could  be merged with `configure-web`. It also templates some sensible defaults depending on the remote host's specifications out to locations which docker will use when the containers are run (usually `/usr/local/web`). It installs some programs, copies a lot of configuration and README files, and sets up cron for web tasks.

Dependencies
------------

`install-general`

Example Playbook
----------------

Since `configure-web` lists `install-web` as a requirement, it suffices simply to run that role:

      hosts: all
      become: true
      roles:
         configure-web

See also
---

https://labs.noflag.org.uk/Noflag/web-two-point-oh/src/master/docs/1.1-Installation-And-Vagrant.md