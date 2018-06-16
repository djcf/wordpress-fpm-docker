install-general
---

A generalized install role for CommonWeal servers. It installs a number of useful utilities like `ctop`, `etckeeper` and the latest version of `docker-compose` and updates the system.

It also uses other ansible roles to install cockpit, fail2ban and supplies the variables to configure the system's mail aliases such that root@ maps to a useable email address.

Dependencies
---
  - role: MichaelRigart.aliases
  - galexrt.cockpit
  - infOpen.fail2ban

Install using ansible-galaxy:

    ansible-galaxy -r requirements.yml

The requirements.yml file is stored in `ansible/`

Example playbook
---

    + hosts: all
      become: true
      roles:
        + install-general