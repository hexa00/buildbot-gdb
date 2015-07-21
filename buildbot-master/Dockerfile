FROM ubuntu:14.04

RUN sed -i 's/archive.ubuntu.com/elx-install.mo.ca.am.ericsson.se/' /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y install python-pip python-dev python-git git
RUN pip install buildbot

RUN buildbot create-master /master

COPY run.sh /run.sh

# Web interface port and slave/master interaction port
EXPOSE 8010 9989
