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
	docker run --rm -i -t \
	  --publish 8010:8010 \
	  --volume $(PWD)/volumes/buildbot-master:/master \
	  --name buildbot-master \
	  buildbot-master:latest

.PHONY: run-slave
run-slave: buildbot-slave/.image-stamp
	docker run --rm -i -t \
	  --link buildbot-master \
	  --volume $(PWD)/volumes/buildbot-slave:/slave \
	  buildbot-slave:latest
