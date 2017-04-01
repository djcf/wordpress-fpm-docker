configure-web
=========
For ansible, installation of this repository is a 4-step process. There are some things which need to be installed, copied, templated or run *after* docker-compose brings up the main container assembly. This role is concerned with doing these things at that time.

Dependencies
------------

The following roles should be run, in order

* install-general
* install-web
* * Run `docker-compose up -d`
* **configure-web**

However for testing or development, it may suffice simply to run `docker-compose up -d` in the `/docker` folder of this repository.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-general
         - install-web