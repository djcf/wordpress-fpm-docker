#!/bin/bash
INVENTORY=.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
if [ $# -eq 0 ]; then
	echo "Enter the host DNS to add to the ansible inventory."
	read host
else
	host=$1
fi
if [ ! grep -q "$host" $INVENTORY ]; then
	echo "master ansible_host=$host" >> $INVENTORY
fi
