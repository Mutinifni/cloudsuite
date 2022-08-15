#!/bin/bash
set -e
set -x

if [ "$2" = '-rps' ]; then
	# default configuration
    echo "$1, 11211" > "/usr/src/memcached/memcached_client/servers.txt"
	/usr/src/memcached/memcached_client/loader \
		-a /usr/src/memcached/twitter_dataset/twitter_dataset_5x \
		-s /usr/src/memcached/memcached_client/servers.txt \
		-g 0.8 -T 1 -c 200 -w 8 -e -r "$3"

else
	# custom command
	exec "$@"
fi
