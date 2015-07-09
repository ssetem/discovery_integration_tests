#!/bin/bash
. utils.bash

require boot2docker
require docker

disco_server_port=4440
disco_server_image=docker.otenv.com/discovery-server:discovery-server-0.8.0

if ! [ -d ./logs ]; then mkdir logs; fi

disco_server_ip() {
	boot2docker ssh ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
}

disco_server_container_id() {
	docker ps | grep $disco_server_image | cut -f1 -d' '
}

start_disco_server() {
	docker run --net=host -p=$disco_server_port:$disco_server_port $disco_server_image > ./logs/discovery-server &
}

stop_disco_server() {
	docker kill $(disco_server_container_id)
}

disco_server_running() {
	if ! curl -fsi $(disco_server_ip):4440/watch > /dev/null; then
		return 1
	else
		return 0
	fi
}

disco_server_url="http://$(disco_server_ip):$disco_server_port"

echo "Discovery server URL: $disco_server_url"

if disco_server_running; then
	container_id=$(disco_server_container_id)
	echo "Discovery server is already running with container ID $container_id"
	echo "Restarting discovery server..."
	stop_disco_server
	start_disco_server
else
	echo "Discovery server not running."
	echo "Starting discovery server..."
	start_disco_server
fi
