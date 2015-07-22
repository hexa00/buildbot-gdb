FROM buildbot-slave:latest

COPY ice-arm-cross-compiler.tar.gz /

RUN sed -i 's/ICECC_ALLOW_REMOTE=\"yes\"/ICECC_ALLOW_REMOTE=\"no\"/' /etc/icecc/icecc.conf

#run-arm.sh
