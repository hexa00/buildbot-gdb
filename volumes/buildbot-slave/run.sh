#!/bin/bash
source env.sh
if [ $1 = "arm" ]; then
source env-arm.sh
fi	 
/etc/init.d/iceccd start
ccache -F 0
ccache -M 10G
buildslave start /slave
