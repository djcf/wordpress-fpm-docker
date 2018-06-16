dns-add-zone
=========

A simple role to facilitate the management of zones using powerdns

Role Variables
--------------

    # defaults file for dns-add-zone
    state: present
    nameservers:
      - ns1.common.scot
      - ns2.common.scot
    pdns_host: pdns.common.scot
    pdns_port: 80

Dependencies    
--------------

This role depends on the `powerdns` ansible module by Nosmoht (https://github.com/Nosmoht/ansible-module-powerdns). If you are using git, it should install automatically including the `ansible/lib` directory if you update submodules. This location is defined by the value of the `lib` variable in `ansible.cfg`.