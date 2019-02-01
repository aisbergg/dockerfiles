include ../../Makefile.mk

USERNAME=aisberg
NAME=base-alpine

ALPINE_MIRROR=http://ftp.halifax.rwth-aachen.de/alpine/
DOCKER_BUILD_ARGS=--pull --build-arg ALPINE_MIRROR=$(ALPINE_MIRROR) --label "org.opencontainers.image.created=$(shell date +'%d-%m-%Y %H:%M:%S %z')"
