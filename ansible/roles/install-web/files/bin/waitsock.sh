#!/bin/sh

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

