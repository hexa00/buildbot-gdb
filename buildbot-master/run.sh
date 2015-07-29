#!/bin/bash

echo "Starting Buildbot master..."

PYTHONPATH=/master/lib buildbot restart --nodaemon /master
