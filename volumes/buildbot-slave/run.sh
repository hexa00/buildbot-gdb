#!/bin/bash
source env.sh
/etc/init.d/iceccd start
ccache -F 0
ccache -M 10G
buildslave start /slave
