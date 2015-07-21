.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Target can be one of:"
	@echo "  - images: Build docker images"

.PHONY: images
images: buildbot-master/.image-stamp
images: buildbot-slave/.image-stamp

buildbot-%/.image-stamp: buildbot-%/Dockerfile
	docker build -t $(subst /,,$(dir $<)) $(subst /,,$(dir $<))
	touch $@

.PHONY: run-master
run-master: buildbot-master/.image-stamp
	if [ ! -f state.sql ]; then \
		cp state.sql.empty state.sql; \
	fi
	docker run --rm -i -t \
	  --publish 8010:8010 \
	  --publish 9989:9989 \
	  --volume $(PWD)/volumes/buildbot-master/master.cfg:/master/master.cfg:ro \
	  --volume $(PWD)/volumes/buildbot-master/lib:/master/lib:ro \
	  --volume $(PWD)/state.sql:/master/state.sql:rw \
	  --name buildbot-master \
	  buildbot-master:latest

.PHONY: run-slave
run-slave: buildbot-slave/.image-stamp
	docker run --rm -i -t \
	  --volume $(PWD)/volumes/buildbot-slave:/slave \
	  buildbot-slave:latest
