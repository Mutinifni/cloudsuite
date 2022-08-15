#!/bin/bash
set -e
set -x

if [ "$2" = '-rps' ]; then
	# default configuration
	echo "$1, 11211" > "/usr/src/memcached/memcached_client/servers.txt"
	/usr/src/memcached/memcached_client/loader \
		-a /usr/src/memcached/twitter_dataset/twitter_dataset_unscaled \
		-o /usr/src/memcached/twitter_dataset/twitter_dataset_30x \
		-s /usr/src/memcached/memcached_client/servers.txt \
		-w 4 -S 30 -D 4096 -j -T 1

else
	# custom command
	exec "$@"
fi
