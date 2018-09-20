USERNAME=aisberg
VERSION_ALPINE=3.8
VERSION_UBUNTU=18.04
UBUNTU_MIRROR=http://ftp.halifax.rwth-aachen.de/ubuntu/
ALPINE_MIRROR=http://ftp.halifax.rwth-aachen.de/alpine/

DOCKER_BUILD_FLAGS?=

.PHONY: build build-alpine build-ubuntu debug-alpine debug-ubuntu push release

build: build-alpine build-ubuntu

build-alpine: update
	cd release &&\
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')" &&\
	docker build --pull -t $(USERNAME)/base-alpine:$(VERSION_ALPINE) -t $(USERNAME)/base-alpine:latest --label org.opencontainers.image.created="$$CREATED" -f Dockerfile-Alpine --build-arg ALPINE_MIRROR=$(ALPINE_MIRROR) $(DOCKER_BUILD_FLAGS) .

build-ubuntu: update
	cd release &&\
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')" &&\
	docker build --pull -t $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) -t $(USERNAME)/base-ubuntu:latest --label org.opencontainers.image.created="$$CREATED" -f Dockerfile-Ubuntu --build-arg UBUNTU_MIRROR=$(UBUNTU_MIRROR) $(DOCKER_BUILD_FLAGS) .

debug-alpine: update
	cd release &&\
	docker build -t $(USERNAME)/base-alpine:$(VERSION_ALPINE) -t $(USERNAME)/base-alpine:latest -f Dockerfile-Alpine $(DOCKER_BUILD_FLAGS) . &&\
	docker run -it --rm $(USERNAME)/base-alpine:$(VERSION_ALPINE) debug

debug-ubuntu: update
	cd release &&\
	docker build -t $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) -t $(USERNAME)/base-ubuntu:latest -f Dockerfile-Ubuntu --build-arg UBUNTU_MIRROR=$(UBUNTU_MIRROR) $(DOCKER_BUILD_FLAGS) . &&\
	docker run -it --rm $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU) debug

push:
	docker push $(USERNAME)/base-alpine:$(VERSION_ALPINE)
	docker push $(USERNAME)/base-alpine:latest
	docker push $(USERNAME)/base-ubuntu:$(VERSION_UBUNTU)
	docker push $(USERNAME)/base-ubuntu:latest

release: build push

update:
	IMAGE_VERSION_ALPINE=$(VERSION_ALPINE) IMAGE_VERSION_UBUNTU=$(VERSION_UBUNTU) bash ./update.sh

default: build
