play-audit
=========

The idea here was that all variables computed during a run or their defaults could be saved to a file in /var/www/$domain after an ansible play is run. That way it could be used with --var-files to repeat the run with the parameters used so that it is easy to modify one.

Work in progress, pulls welcome.