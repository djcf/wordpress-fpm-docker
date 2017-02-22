### Optimizations

It has the following out-of-box optimizations:

* Nginx serves most content statically, directly from the filesystem. Without needing to load a php interpreter, this is incredibly fast and memory-efficient. It also pre-configures a cache.
* Php7 bundles a just-in-time php interpreter, which uses one of the fastest opcaches available.
* All of the core system docker images are based on Alpine
* All of the core containers are based on the Docker-official images where possible.
* As noted above, systemd knows how to pause Wordpress containers which don't receive traffic inside a predetermined period and start them again on-demand.
* Images automatically-shrunk by cron.