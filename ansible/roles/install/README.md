install
========

Dependencies
------------

`install-general`

Example Playbook
----------------

Since `configure-web` lists `install-web` as a requirement, it suffices simply to run that role:

      hosts: all
      become: true
      roles:
         install

See also
---

https://labs.common.scot/CommonWeal/web-two-point-oh/src/master/docs/1.1-Installation-And-Vagrant.md