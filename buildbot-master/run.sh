#!/bin/bash

echo "Starting Buildbot master..."

PYTHONPATH=/master/lib buildbot stop /master
PYTHONPATH=/master/lib buildbot start --nodaemon /master
