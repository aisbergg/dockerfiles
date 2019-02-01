include ../../Makefile.mk

USERNAME=aisberg
NAME=base-ubuntu

UBUNTU_MIRROR=http://ftp.halifax.rwth-aachen.de/ubuntu/
DOCKER_BUILD_ARGS=--pull --build-arg UBUNTU_MIRROR=$(UBUNTU_MIRROR) --label "org.opencontainers.image.created=$(shell date +'%d-%m-%Y %H:%M:%S %z')"
