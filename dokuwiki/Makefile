USERNAME=aisberg
NAME=dokuwiki
VERSION=2017-02-19e

.PHONY: build debug push rmi release

build:
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')"
	docker build -t $(USERNAME)/$(NAME):$(VERSION) -f Dockerfile --build-arg CREATED="$$CREATED" .
	docker tag $(USERNAME)/$(NAME):$(VERSION) $(USERNAME)/$(NAME):latest

debug:
	docker build -t $(USERNAME)/$(NAME):$(VERSION) -f Dockerfile .
	docker run -it --rm $(USERNAME)/$(NAME):$(VERSION) debug

push:
	docker push $(USERNAME)/$(NAME):$(VERSION)
	docker push $(USERNAME)/$(NAME):latest

release: build push

rmi:
	docker rmi $(USERNAME)/$(NAME):$(VERSION)
	docker rmi $(USERNAME)/$(NAME):latest

default: build
