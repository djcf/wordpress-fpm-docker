Migrating a site from alba
---

1. Run plays/alba/export-from-alba.yml

    ansible-playbook -i "alba.common.scot, " plays/alba/export-from-alba.yml

2. Enter the name of the alba user(s) with wordpress websites you would like to export when prompted
    
3. If a wp-config.php file can be found in either /var/www/customers/$alba-user/ or /var/www/customers/$alba-user/public_html, load their database details and do a mysql dump to their web directory.

4. Zip their wp-content file and database dump and download to the ansible control machine.

5. Creates a file named `from-alba/$alba-user.yml` with details from the current migrate. Open the file manually and check that the details are correct:

    cat plays/alba/from-alba/$alba-user.yml
    primary_subdomain: xxx
    domains: xxx.common.scot
    zipped_filename: from-alba/xxx.zip

6. If these details are correct, run `plays/alba/import.yml`

    ansible-playbook -i "www2.common.scot, " plays/alba/import.yml

7. Enter the name of the .yml file with variables from the desired export (usually the same as the alba username) when prompted.

Issues
---
Some bugs remain.

The import script does not import to the right place and the database import fails. Go to /var/www/$primary_subdomain and run /usr/local/bin/import-database.sh (pwd)/.env (pwd)/database.sql.gz then move the wp-content directory to the right place.

    cd /var/www/$primary_subdomain
    /usr/local/bin/import-database.sh $(pwd)/.env $(pwd)/database.sql.gz
    rm -rf public_html/wp-content
    mv wp-content public_html/wp-content

You may then need to recreate the container:

    /usr/local/bin/renew-fpm-container $primary_subdomain