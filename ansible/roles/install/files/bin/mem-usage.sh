#!/bin/bash

if [ $# -gt 1 ]; then
	echo "Prints the average memory useage of a group of processes (e.g. try with php to see all php processes)"
	exit
fi

ps --no-headers -o "rss,cmd" -C $1 | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'
