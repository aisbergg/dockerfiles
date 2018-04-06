USERNAME=aisberg
VERSION_ALPINE=3.7
VERSION_UBUNTU=17.10
UBUNTU_MIRROR=http://ftp.halifax.rwth-aachen.de/ubuntu/

CREATED=$(shell date +'%d-%m-%Y %H:%M:%S %z')

.PHONY: build build-alpine build-ubuntu push release

build: build-alpine build-ubuntu

build-alpine:
	docker build -t $(USERNAME)/base-alpine:$(VERSION_ALPINE) -f Dockerfile-Alpine --build-arg CREATED="$(CREATED)" . ; \
	docker tag $(USERNAME)/base-alpine:$(VERSION_ALPINE) $(USERNAME)/base-alpine:latest

build-ubuntu:
	docker build -t $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) -f Dockerfile-Ubuntu --build-arg UBUNTU_MIRROR=$(UBUNTU_MIRROR) --build-arg CREATED="$(CREATED)" . ; \
	docker tag $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) $(USERNAME)/base-ubuntu:latest

push:
	docker push $(USERNAME)/base-alpine:$(VERSION_ALPINE) ; \
	docker push $(USERNAME)/base-alpine:latest ; \
	docker push $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) ; \
	docker push $(USERNAME)/base-ubuntu:latest ;

release: build push

default: build
