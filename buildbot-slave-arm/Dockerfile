FROM mazzolino/armhf-ubuntu:14.04

COPY ice-arm-cross-compiler.tar.gz /

RUN apt-get update && \
    apt-get -y install python-pip python-dev git ntpdate ntp ccache icecc && \
    apt-get -y build-dep gdb


RUN sed -i 's/ICECC_SCHEDULER_HOST=\"\"/ICECC_SCHEDULER_HOST=\"142.133.110.95\"/' /etc/icecc/icecc.conf && \
    sed -i 's/ICECC_ALLOW_REMOTE=\"yes\"/ICECC_ALLOW_REMOTE=\"no\"/' /etc/icecc/icecc.conf


RUN echo "America/Montreal" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

#set ntp servers
RUN sed -i 's/server [0-9]\.ubuntu\.pool\.ntp\.org//' /etc/ntp.conf
RUN echo "server ntp1.ericsson.se" >> /etc/ntp.conf && \
    echo "server ntp2.ericsson.se" >> /etc/ntp.conf

RUN /etc/init.d/ntp restart

RUN pip install buildbot-slave

COPY run.sh /run.sh

CMD /run.sh
