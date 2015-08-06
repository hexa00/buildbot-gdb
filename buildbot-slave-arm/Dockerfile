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

# Install buildbot from git in order to get the fix for GerritChangeSource.
ENV BUILDBOT_COMMIT=33c1baccf1836150ac201ffdd34019f6877fd4b3
RUN git clone https://github.com/buildbot/buildbot.git --branch eight buildbot-git && \
    git -C buildbot-git checkout $BUILDBOT_COMMIT && \
    pip install buildbot-git/slave && \
    rm -rf buildbot-git

COPY run.sh /run.sh
COPY common/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
COPY common/known_hosts /etc/ssh/ssh_known_hosts

CMD /run.sh
