USERNAME=aisberg
NAME=nginx-node
NODE_VERSIONS=11 10 8

DOCKER_BUILD_FLAGS?=
SHELL=/bin/bash

build_targets=$(addprefix build-, $(NODE_VERSIONS))
.PHONY: build push release
all: $(build_targets)

$(build_targets): build-%: release/Dockerfile-Node-%
	CREATED="$(shell date +'%d-%m-%Y %H:%M:%S %z')" &&\
	df=$< && df="$${df#*/}" && version=$${df##*-} &&\
	bash ./update.sh &&\
	cd release &&\
	docker build -t $(USERNAME)/$(NAME):$$version --label org.opencontainers.image.created="$$CREATED" -f Dockerfile-Node-$$version $(DOCKER_BUILD_FLAGS) . &&\
	if [[ $$version == $$(echo $(NODE_VERSIONS) | awk '{ print $$1 }') ]]; then docker tag $(USERNAME)/$(NAME):$$version $(USERNAME)/$(NAME):latest ; fi

build: $(build_targets)

push:
	for version in $(NODE_VERSIONS) ; do \
		docker push $(USERNAME)/$(NAME):$$version  ; \
	done &&\
	docker push $(USERNAME)/$(NAME):latest

release: build push

update:
	bash ./update.sh

default: build
