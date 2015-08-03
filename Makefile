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
	@echo "  - stop-master"
	@echo "        Stop and delete a running master instance."
	@echo "  - stop-slave SLAVE_NAME=<name>"
	@echo "        Stop and delete a running slave instance."

.PHONY: images
images: buildbot-master/.image-stamp
images: buildbot-slave/.image-stamp
buildbot-master/.image-stamp: buildbot-master/run.sh
buildbot-slave/.image-stamp: buildbot-slave/run.sh

buildbot-%/.image-stamp: buildbot-%/Dockerfile
	docker build -t $(subst /,,$(dir $<)) $(subst /,,$(dir $<))
	touch $@

CMD ?= /run.sh

.PHONY: run-master
run-master: buildbot-master/.image-stamp
	mkdir -p buildbot-master-data
	mkdir -p buildbot-master-public_html
	if [ ! -f buildbot-master-data/state.sqlite ]; then \
		cp state.sqlite.empty buildbot-master-data/state.sqlite; \
	fi
	touch twistd_master.log
	docker run -d \
	  --publish 8010:8010 \
	  --publish 9989:9989 \
	  --volume $(PWD)/volumes/buildbot-master/master.cfg:/master/master.cfg:rw \
	  --volume $(PWD)/volumes/buildbot-master/lib:/master/lib:ro \
	  --volume $(PWD)/buildbot-master-data:/master/data:rw \
	  --volume $(PWD)/buildbot-master-public_html:/master/public_html:rw \
	  --volume $(PWD)/twistd_master.log:/master/twistd.log:rw \
	  --name buildbot-master \
	  buildbot-master:latest $(CMD)

.PHONY: stop-master
stop-master:
	docker stop buildbot-master
	docker rm buildbot-master

# Check that all variables required for run-slave are defined.
.PHONY: check-run-slave
check-run-slave:
	@if [ -z "$(SLAVE_MASTER_HOSTPORT)" ]; then echo "Missing SLAVE_MASTER_HOSTPORT"; exit 1; fi
	@if [ -z "$(SLAVE_NAME)" ]; then echo "Missing SLAVE_NAME"; exit 1; fi
	@if [ -z "$(SLAVE_PASSWD)" ]; then echo "Missing SLAVE_PASSWD"; exit 1; fi

.PHONY: run-slave
run-slave: buildbot-slave/.image-stamp | check-run-slave
	touch twistd_$(SLAVE_NAME).log
	docker run -d \
	  -p 10245:10245 \
	  --volume $(PWD)/twistd_$(SLAVE_NAME).log:/slave/twistd.log:rw \
	  --name buildbot-$(SLAVE_NAME) \
	  buildbot-slave:latest \
	  /run.sh $(SLAVE_MASTER_HOSTPORT) $(SLAVE_NAME) $(SLAVE_PASSWD)

.PHONY: run-slave-on-host
run-slave-on-host: buildbot-slave/.image-stamp | check-run-slave
	touch twistd_$(SLAVE_NAME).log
	docker run -d \
	  --net=host \
	  --volume $(PWD)/twistd_$(SLAVE_NAME).log:/slave/twistd.log:rw \
	  --name buildbot-$(SLAVE_NAME) \
	  buildbot-slave:latest \
	  /run.sh $(SLAVE_MASTER_HOSTPORT) $(SLAVE_NAME) $(SLAVE_PASSWD)

.PHONY: run-slave-arm
run-slave-arm: buildbot-slave-arm/.image-stamp | check-run-slave
	touch twistd_$(SLAVE_NAME).log
	docker run -d \
	  -p 10245:10245 \
	  --volume $(PWD)/twistd_$(SLAVE_NAME).log:/slave/twistd.log:rw \
	  --name buildbot-$(SLAVE_NAME) \
	  buildbot-slave-arm:latest \
	  /run.sh $(SLAVE_MASTER_HOSTPORT) $(SLAVE_NAME) $(SLAVE_PASSWD)

.PHONY: check-stop-slave
check-stop-slave:
	@if [ -z "$(SLAVE_NAME)" ]; then echo "Missing SLAVE_NAME"; exit 1; fi

.PHONY: stop-slave
stop-slave: | check-stop-slave
	docker stop buildbot-$(SLAVE_NAME)
	docker rm buildbot-$(SLAVE_NAME)
