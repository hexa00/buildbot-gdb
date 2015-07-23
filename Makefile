.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Target can be one of:"
	@echo "  - images: Build docker images"
	@echo "  - run-master [CMD=<cmd>]: Run a master instance"
	@echo "        CMD can be used to override the command ran in the container."
	@echo "  - run-slave [CMD=<cmd>]: Run a slave instance"
	@echo "        CMD can be used to override the command ran in the container."

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
	docker run --rm -i -t \
	  --volume $(PWD)/volumes/buildbot-slave:/slave \
	  buildbot-slave:latest $(CMD)
