FROM ubuntu:14.04

RUN sed -i 's/archive.ubuntu.com/elx-install.mo.ca.am.ericsson.se/' /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y install python-pip python-dev git ntpdate ntp ccache icecc && \
    apt-get -y build-dep gdb


RUN sed -i 's/ICECC_SCHEDULER_HOST=\"\"/ICECC_SCHEDULER_HOST=\"142.133.110.95\"/' /etc/icecc/icecc.conf

RUN echo "America/Montreal" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

#set ntp servers
RUN sed -i 's/server [0-9]\.ubuntu\.pool\.ntp\.org//' /etc/ntp.conf
RUN echo "server ntp1.ericsson.se" >> /etc/ntp.conf && \
    echo "server ntp2.ericsson.se" >> /etc/ntp.conf

RUN /etc/init.d/ntp restart

RUN pip install buildbot-slave

COPY run.sh /run.sh

CMD /run.sh
