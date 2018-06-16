#!/bin/sh

# Proxies a unix socket until an application is ready
# Used by systemd. See https://labs.common.scot/CommonWeal/web-two-point-oh/src/master/docs/1.2-On-Demand-Containers.md

tries=600

for i in `seq $tries`; do
    if [ -S $1 ]; then
      # Ready
      exit 0
    fi

    /bin/sleep 0.1
done

# FAIL
exit -1

