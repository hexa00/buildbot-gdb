#!/usr/bin/env bash

# Print help and exit with the specified exit code.
#
# $1: The value to pass to exit
function help_and_exit() {
	echo "Usage:"
	echo "  $0 master-hostname[:master-port] [name] [passwd]"

	echo ""
	echo "Description:"
	echo ""
	echo "  Create and start a buildbot slave."
	echo ""
	echo "Positional arguments:"
	echo ""
	echo "  master-hostname: Hostname of Buildbot master."
	echo "  master-port: Port of Buildbot master (default: 9989)."
	echo "  name: Slave's name as registered in the master."
	echo "  passwd: Slave's password as registered in the master."
	echo ""
	echo "Optional arguments:"
	echo ""
	echo "  -h, --help           Print this help message and exit."
	echo ""

	exit $1
}

if [ "$(uname -m)" != "x86_64" ]; then
	ICECC_VERSION_VAR="ICECC_VERSION='x86_64:/ice-arm-cross-compiler.tar.gz'"
fi

args=$(getopt -o 'h' -l 'help' -n "$0" -- "$@")

eval set -- "$args"

# Bad arguments ?
if [ $? -ne 0 ]; then
  exit 1
fi

while true; do
	case "$1" in
	-h|--help)
		help_and_exit 0
		break
		;;

	--)
		shift;
		break;
		;;
	esac
done

if [ "$#" -ne "3" ]; then
	echo "Wrong number of parameters."
	echo ""
	help_and_exit 1
fi

master_hostport="$1"; shift
slave_name="$1"; shift
slave_passwd="$1"; shift

service iceccd start

ccache -F 0
ccache -M 10G

buildslave create-slave -r "/slave" "$master_hostport" "$slave_name" "$slave_passwd"

echo "Starting buildbot slave..."

env \
	CCACHE_PREFIX=icecc \
	PATH=/usr/lib/ccache:${PATH} \
	${ICECC_VERSION_VAR} \
	buildslave start --nodaemon "/slave"
