USERNAME=aisberg
NAME=html-php5

.PHONY: build debug push rmi release

build:
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')"; \
	docker build -t $(USERNAME)/$(NAME):latest -f Dockerfile --build-arg CREATED="$$CREATED" .

debug:
	docker build -t $(USERNAME)/$(NAME):latest -f Dockerfile . ; \
	docker run -it --rm $(USERNAME)/$(NAME):latest debug

push:
	docker push $(USERNAME)/$(NAME):latest

release: build push

rmi:
	docker rmi $(USERNAME)/$(NAME):latest

default: build
