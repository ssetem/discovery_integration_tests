die() {
	echo $1 1>&2
	exit 1
}

require() {
	if ! command -v $1 2>&1>/dev/null; then
		die "$1 not found"
	fi
}
