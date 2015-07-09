#!/bin/bash
. utils.bash

require boot2docker

disco_server_port=4440
disco_server_image=docker.otenv.com/discovery-server:discovery-server-0.8.0

disco_server_ip() {
	boot2docker ssh ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
}

start_disco_server() {
	docker run -p$disco_server_port:$disco_server_port $disco_server_image
}

disco_server_running() {
	if ! curl -fsi $(disco_server_ip):4440/watch > /dev/null; then
		return 1
	else
		return 0
	fi
}

DISCOVERY_URL="http://$(disco_server_ip):$disco_server_port"

echo "Discovery server IP: $(disco_server_ip)"

if disco_server_running; then
	echo "Discovery server is already running"
else
	echo "Discovery server not running."
fi
