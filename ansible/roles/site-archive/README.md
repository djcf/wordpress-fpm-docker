site-archive
=========

This role takes a canonical domain name and archives it using wget on the archive host. It then transfers a full site backup to the archive host and templates a vhost for the archived site to use.

Role Variables
--------------

    archive-host: bhagat.noflag.org.uk

The archive host to use.

Dependencies
------------

    - site-export
    - nginx-base

Example Playbook
----------------

See `ansible/plays/archive-site.yml`

Known issues
----
Completely untested.