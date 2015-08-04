#!/bin/bash

# Print help and exit with the specified exit code.
#
# $1: The value to pass to exit
function help_and_exit() {
	echo "Usage:"
	echo "  $0 master-hostname[:master-port] [name] [passwd] [gerrit user]"

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

if [ "$#" -ne "1" ]; then
	echo "Wrong number of parameters."
	echo ""
	help_and_exit 1
fi

gerrit_user="$1"; shift

echo "Starting Buildbot master..."

PYTHONPATH=/master/lib buildbot stop /master
PYTHONPATH=/master/lib GERRIT_USER=${gerrit_user} buildbot start --nodaemon /master
