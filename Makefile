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
