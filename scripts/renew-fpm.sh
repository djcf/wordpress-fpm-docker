#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Useage: $0 DOMAIN"
    exit 1
fi

systemctl stop fpm@$1.service
systemctl disable fpm@$1.service
systemctl stop fpm-waker@$1.service
systemctl disable fpm-waker@$1.service
systemctl stop fpm-waker@$1.socket
systemctl disable fpm-waker@$1.service
rm -f /var/run/docker-apps/$1/*
systemctl enable fpm-waker@$1.socket
systemctl start fpm-waker@$1.socket