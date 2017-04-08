#!/bin/bash
IFS=$'\n'
for v in $(docker volume ls -q); do
        if [ ${#v} -ne 64 ]; then
                if [ $# -eq 0 ]; then
                        echo $v
                else
                        if [ "$1" == "-v" ]; then
                                echo "$v: /var/lib/docker/volumes/$v/_data"
                        elif [ "$1" == "-f" ]; then
                                echo "/var/lib/docker/volumes/$v/_data"
                        fi
                fi
        fi
done
