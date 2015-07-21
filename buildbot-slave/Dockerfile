FROM ubuntu:14.04

RUN sed -i 's/archive.ubuntu.com/elx-install.mo.ca.am.ericsson.se/' /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y install python-pip python-dev git
RUN apt-get -y build-dep gdb
RUN pip install buildbot-slave

VOLUME /slave
