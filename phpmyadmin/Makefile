USERNAME=aisberg
NAME=phpmyadmin
VERSION=4.8.5

DOCKER_BUILD_FLAGS?=

.PHONY: build debug push rmi release

build:
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')" &&\
	docker build -t $(USERNAME)/$(NAME):$(VERSION) -t $(USERNAME)/$(NAME):latest --label org.opencontainers.image.created="$$CREATED" -f Dockerfile $(DOCKER_BUILD_FLAGS) .

debug:
	docker build -t $(USERNAME)/$(NAME):$(VERSION) -t $(USERNAME)/$(NAME):latest --label org.opencontainers.image.created="$$CREATED" -f Dockerfile $(DOCKER_BUILD_FLAGS) .
	docker run -it --rm --user root $(USERNAME)/$(NAME):$(VERSION) debug

push:
	docker push $(USERNAME)/$(NAME):$(VERSION)
	docker push $(USERNAME)/$(NAME):latest

release: build push

rmi:
	docker rmi $(USERNAME)/$(NAME):$(VERSION)
	docker rmi $(USERNAME)/$(NAME):latest

default: build
