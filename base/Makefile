USERNAME=aisberg
VERSION_ALPINE=3.7
VERSION_UBUNTU=17.10
UBUNTU_MIRROR=http://ftp.halifax.rwth-aachen.de/ubuntu/
ALPINE_MIRROR=http://ftp.halifax.rwth-aachen.de/alpine/v3.7/

DOCKER_BUILD_FLAGS?=

CREATED=$(shell date +'%d-%m-%Y %H:%M:%S %z')

.PHONY: build build-alpine build-ubuntu debug-alpine debug-ubuntu push release

build: build-alpine build-ubuntu

build-alpine: update
	cd release &&\
	docker build --pull -t $(USERNAME)/base-alpine:$(VERSION_ALPINE) -f Dockerfile-Alpine --build-arg ALPINE_MIRROR=$(ALPINE_MIRROR) --build-arg CREATED="$(CREATED)" $(DOCKER_BUILD_FLAGS) . &&\
	docker tag $(USERNAME)/base-alpine:$(VERSION_ALPINE) $(USERNAME)/base-alpine:latest

build-ubuntu: update
	cd release &&\
	docker build --pull -t $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) -f Dockerfile-Ubuntu --build-arg UBUNTU_MIRROR=$(UBUNTU_MIRROR) --build-arg CREATED="$(CREATED)" $(DOCKER_BUILD_FLAGS) . &&\
	docker tag $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) $(USERNAME)/base-ubuntu:latest

debug-alpine: update
	cd release &&\
	docker build -t $(USERNAME)/base-alpine:$(VERSION_ALPINE) -f Dockerfile-Alpine $(DOCKER_BUILD_FLAGS) . &&\
	docker run -it --rm $(USERNAME)/base-alpine:$(VERSION_ALPINE) debug

debug-ubuntu: update
	cd release &&\
	docker build -t $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) -f Dockerfile-Ubuntu --build-arg UBUNTU_MIRROR=$(UBUNTU_MIRROR) $(DOCKER_BUILD_FLAGS) . &&\
	docker run -it --rm $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) debug

push:
	docker push $(USERNAME)/base-alpine:$(VERSION_ALPINE)
	docker push $(USERNAME)/base-alpine:latest
	docker push $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU)
	docker push $(USERNAME)/base-ubuntu:latest ;

release: build push

update:
	bash ./update.sh

default: build
