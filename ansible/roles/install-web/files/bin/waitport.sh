#!/bin/sh

# Proxies a TCP port until an application is ready
# Unused. See https://labs.noflag.org.uk/Noflag/web-two-point-oh/src/master/docs/1.2-On-Demand-Containers.md

host=$1
port=$2
tries=600

for i in `seq $tries`; do
    if /bin/nc -z $host $port > /dev/null ; then
      # Ready
      exit 0
    fi

    /bin/sleep 0.1
done

# FAIL
exit -1