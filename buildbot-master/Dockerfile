FROM ubuntu:14.04

RUN sed -i 's/archive.ubuntu.com/elx-install.mo.ca.am.ericsson.se/' /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y install python-pip python-dev python-git git ntp ntpdate


RUN echo "America/Montreal" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
#set ntp servers
RUN sed -i 's/server [0-9]\.ubuntu\.pool\.ntp\.org//' /etc/ntp.conf
RUN echo "server ntp1.ericsson.se" >> /etc/ntp.conf && \
    echo "server ntp2.ericsson.se" >> /etc/ntp.conf
RUN /etc/init.d/ntp restart

RUN pip install buildbot

RUN buildbot create-master /master

COPY run.sh /run.sh

# Web interface port and slave/master interaction port
EXPOSE 8010 9989
