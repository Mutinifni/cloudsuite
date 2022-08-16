#!/bin/bash
set -e
set -x

if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$  ]]; then
	# default server configuration
	echo "$1, 11211" > "/usr/src/memcached/memcached_client/servers.txt"

    if [[ "$2" = "load" ]]; then
        # scale up dataset and warmup keys
	    /usr/src/memcached/memcached_client/loader \
	    	-a /usr/src/memcached/twitter_dataset/twitter_dataset_unscaled \
	    	-o /usr/src/memcached/twitter_dataset/twitter_dataset_30x \
	    	-s /usr/src/memcached/memcached_client/servers.txt \
	    	-w 4 -S 30 -D 4096 -j -T 1
        exec "bash"

    elif [[ "$2" = "find_rps" ]]; then
        # find max throughput rps
	    /usr/src/memcached/memcached_client/loader \
	    	-a /usr/src/memcached/twitter_dataset/twitter_dataset_30x \
	    	-s /usr/src/memcached/memcached_client/servers.txt \
	    	-g 0.8 -T 1 -c 200 -w 8
        exec "bash"

    elif [[ "$2" = "run" ]]; then
        # run benchmark
        /usr/src/memcached/memcached_client/loader \
    		-a /usr/src/memcached/twitter_dataset/twitter_dataset_30x \
    		-s /usr/src/memcached/memcached_client/servers.txt \
    		-g 0.8 -T 1 -t 120 -c 200 -w 8 -e -r "$3"

    else
        echo "Command not recognized"
    fi

else
	# custom command
	exec "$@"
fi

