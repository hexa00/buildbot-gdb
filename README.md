# Instructions
## Build the docker images
```
buildbot-gdb/ $ docker build -t buildbot-master buildbot-master
buildbot-gdb/ $ docker build -t buildbot-slave buildbot-slave
```

## Run the docker images
```
buildbot-gdb/ $ docker run --rm -i -t -p 8010:8010 -v $PWD/volumes/buildbot-master:/master --name buildbot-master buildbot-master:latest
buildbot-gdb/ $ docker run --rm -i -t --link buildbot-master -v $PWD/volumes/buildbot-slave:/slave buildbot-slave:latest
