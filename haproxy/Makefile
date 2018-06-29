USERNAME=aisberg
NAME=haproxy
VERSION=1.8.12

DOCKER_BUILD_FLAGS?=

.PHONY: build debug push rmi release update

build: update
	cd release &&\
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')" &&\
	docker build -t $(USERNAME)/$(NAME):$(VERSION) -f Dockerfile --build-arg CREATED="$$CREATED" $(DOCKER_BUILD_FLAGS) . &&\
	docker tag $(USERNAME)/$(NAME):$(VERSION) $(USERNAME)/$(NAME):latest

debug:
	cd release &&\
	docker build -t $(USERNAME)/$(NAME):$(VERSION) -f Dockerfile $(DOCKER_BUILD_FLAGS) . &&\
	docker run -it --rm $(USERNAME)/$(NAME):$(VERSION) debug

push:
	docker push $(USERNAME)/$(NAME):$(VERSION)
	docker push $(USERNAME)/$(NAME):latest

release: build push

rmi:
	docker rmi $(USERNAME)/$(NAME):$(VERSION)
	docker rmi $(USERNAME)/$(NAME):latest

update:
	IMAGE_VERSION=$(VERSION) bash ./update.sh

default: build
