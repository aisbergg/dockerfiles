USERNAME=aisberg
NAME=html-php5

DOCKER_BUILD_FLAGS?=

.PHONY: build debug push rmi release

build:
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')"
	docker build -t $(USERNAME)/$(NAME):latest -f Dockerfile --build-arg CREATED="$$CREATED" $(DOCKER_BUILD_FLAGS) .

debug:
	docker build -t $(USERNAME)/$(NAME):latest -f Dockerfile $(DOCKER_BUILD_FLAGS) .
	docker run -it --rm $(USERNAME)/$(NAME):latest debug

push:
	docker push $(USERNAME)/$(NAME):latest

release: build push

rmi:
	docker rmi $(USERNAME)/$(NAME):latest

default: build
