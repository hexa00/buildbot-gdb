.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Target can be one of:"
	@echo "  - images: Build docker images"
	@echo "  - run-master [CMD=<cmd>]"
	@echo "        Run a master instance. CMD can be used to override the command ran in"
	@echo "        the container."
	@echo "  - run-slave SLAVE_MASTER_HOSTPORT=<hostport> SLAVE_NAME=<name> SLAVE_PASSWD=<passwd>"
	@echo "        Run a slave instance."

.PHONY: images
images: buildbot-master/.image-stamp
images: buildbot-slave/.image-stamp

buildbot-%/.image-stamp: buildbot-%/Dockerfile
	docker build -t $(subst /,,$(dir $<)) $(subst /,,$(dir $<))
	touch $@

CMD ?= /run.sh

.PHONY: run-master
run-master: buildbot-master/.image-stamp
	if [ ! -f state.sqlite ]; then \
		cp state.sqlite.empty state.sqlite; \
	fi
	docker run --rm -i -t \
	  --publish 8010:8010 \
	  --publish 9989:9989 \
	  --volume $(PWD)/volumes/buildbot-master/master.cfg:/master/master.cfg:ro \
	  --volume $(PWD)/volumes/buildbot-master/lib:/master/lib:ro \
	  --volume $(PWD)/state.sqlite:/master/state.sqlite:rw \
	  --name buildbot-master \
	  buildbot-master:latest $(CMD)

.PHONY: run-slave
run-slave: buildbot-slave/.image-stamp
	touch twistd_$(SLAVE_NAME).log
	docker run --rm -i -t \
	  --volume $(PWD)/twistd_$(SLAVE_NAME).log:/slave/twistd.log:rw \
	  buildbot-slave:latest \
	  /run.sh $(SLAVE_MASTER_HOSTPORT) $(SLAVE_NAME) $(SLAVE_PASSWD)
