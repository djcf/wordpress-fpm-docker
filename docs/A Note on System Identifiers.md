## Creating websites -- read me first!

As you know, a website is more than just a collection of static HTML. It's more even than a codebase of executable or interpeted code (e.g. php), a backing database, and web server software in front. A website, conceptually, also has to encompass the full gamut of SSL certificates and keys, virtual hosts, random seeds, database usernames and passwords, file system paths populated with their desired content, and so on. **So when running nearly any ansible play, ansible needs to know what website you want to want to perform the task on.**

All of this information is determined programatically by ansible in a way which tries to be compliant. In other words if you know one thing about the site like the name of the database or the database user, it should be easy to deduce other things like the virtual host name. However, this can only go so far. Each 'website' (or 'user') of the system has at least three things which ansible needs to know:

* **The primary subdomain**, i.e. the "example" part of example.noflag.org.uk. If you are ever asked by ansible for a primary subdomain, **do not** enter the full domain. I.e., type 'example', do **not** type 'example.noflag.org.uk'. All websites have a primary subdomain in case the primary domain becomes inaccessible.

* **The primary domain**. This may or may not be seeded by the primary subdomain. It is **always** a fully-qualified domain name (FQDN). If left blank, ansible will deduce it by appending 'noflag.org.uk' to the primary subdomain.

* Finally and least importantly, a list of other FQDNs the website can be accessed at. If the primary domain **is not** equal to  `$primary_subdomain.noflag.org.uk`, this list will automatically include `www.$primary_domain`.

Thus, with default options, the domain list will usually be:

    $primary_subdomain.noflag.org.uk
    $primary_domain
    www.$primary_domain

This domain list is generated automatically as much as possible, but your input will be solicited when you run a create-website play.

**For other tasks**, like 

## Identity

At some level, it's nessessary to keep track of what parts of the system, i.e. what files, relate to which other parts, for example which vhost file relates to which Wordpress directory when a vhost may be declared for several domains or subdomains. This particular system tries to be as descriptive as possible, rather than prescriptive like Cpanel or Froxlor. But it's still nessessary. 

With Froxlor, each `user` entity may have one or more domains, websites, etc. but there's no way to get to a domain or website just because you know the username. If browsing through /var/webs/customers, you can't know what domain each site serves except by guessing.

In the begining, it was decided that each unique entity would be represented by one and only one domain, referred to as `$domain`. From this, we could generate web storage paths (`/var/www/$domain`), container name (`$domain.fpm`), vhost files (`$vhost-storage/$domain.conf`), certificate files (`$domain.pem`) and so on. Furthuremore: $domain_user and $domain_db in SQL.

However, it's an unfortunate fact that not all domains will be valid for the lifecycle of a website. Sometimes users want to create a temporary subdomain to develop their site, then move to a full domain after they've purchased one. Sometimes domains expire. Therefore, it is a **requirement** that **all** websites have a valid primary subdomain which they can use to access their site for the its entire lifetime, almost always a subdomain parked under the primary host provider, for example `sitename.noflag.org.uk`.

Given that a primary subdomain will **always** exist **and** have a **1-to-1 mapping with a website**, it was decided that the primary subdomain FQDN would be used as a unique identifier rather than the primary domain. I.e., the unique identifier used for vhosts, SSL certificates, web storage paths and so on, was to be the primary subdomain writen as an FQDN like `example.noflag.org.uk`. *For a requested website living at example.org, the user was to be identified by the primary system id `example.noflag.org.uk`.*

Although simple for sysadmins to read and interpret in the context of, e.g., a system path or container name, it does lead to the situation where the last 14-letters of the primary identifier are completely superfluous. Therefore, the ansible buildscripts were updated to instead refer not to `$domain` but to the unique key prefixed in front of every primary subdomain, `example` in the context of `example.noflag.org.uk`. **It will always be the case that a valid subdomain will exist at `.noflag.org.uk` for each primary identifier**.

The docs have not all been updated to take this into account. You may find references to `$domain` or to `$primary subdomain` in some contexts. They all mean the same thing: the bit before .noflag.org.uk in an FQDN which is used as a system-unique identifier.

## See also

* Wordpress troubleshooting

## Appendix

Here's a list of most occurences of the $primary_subdomain:

* Domain $primary_subdomain.noflag.org.uk
* Directory /var/www/$primary_subdomain
* Php container $primary_subdomain.fpm
* systemd unit fpm@$primary_subdomain.service and fpm-waker@$primary_subdomain.service and .socket
* Vhost /var/lib/docker/volumes/docker_sites_enabled/on-demand/$primary_subdomain.conf
* Vhost include /var/lib/docker/volumes/docker_vhost_inc/$primary_subdomain.conf
* Remote/proxied vhost /var/lib/docker/volumes/docker_sites_enabled/archive-hosts/$primary_subdomain.conf
* Php pool (in php group container) /var/lib/docker/volumes/docker_sites_enabled/group-fpm/$primary_subdomain.conf
* Conf file /var/lib/docker/volumes/group-php-fpm/$primary_subdomain.conf
* SSL certificate /var/lib/docker/volumes/ssl-certs/$primary_subdomain.crt
* SSL key /var/lib/docker/volumes/ssl-certs/$primary_subdomain.key
* DHParam seed for SSL /var/lib/docker/volumes/ssl-certs/$primary_subdomain.dhparam.pem
* DB user $primary_subdomain_user
* SQL database $primary_subdomain_db
* Unix system user (only in php group container) $primary_subdomain_user

In the future, we might expect these uses to be valid as well:

* An FTP/SFTP/SCP/SSH user using jailshell (to copy files to host)
* A mail domain admin if applicable with their own master account on the mail server