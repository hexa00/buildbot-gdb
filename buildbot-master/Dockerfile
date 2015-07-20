FROM ubuntu:14.04
RUN sed -i 's/archive.ubuntu.com/elx-install.mo.ca.am.ericsson.se/' /etc/apt/sources.list
RUN apt-get update
RUN apt-cache search pip
RUN apt-get -y install python-pip python-dev git
RUN pip install buildbot
VOLUME /master
# Web interface port
EXPOSE 8010
