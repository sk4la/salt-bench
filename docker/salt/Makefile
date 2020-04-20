DOCKER_BINARY?=docker
DOCKER_BUILD_CONTEXT?=.
DOCKER_BUILD_FLAGS+=
DOCKER_DOCKERFILE?=Dockerfile
DOCKER_PUSH_FLAGS+=
DOCKER_REPOSITORY?=docker.io/sk4labs
DOCKER_RESOURCE?=salt
DOCKER_RESOURCE_TAG?=alpine
DOCKER_RUN_CMD?=
DOCKER_RUN_ENTRYPOINT?=/bin/ash
DOCKER_RUN_FLAGS+=

ifndef DOCKER_BINARY
	$(error Docker is required to build and/or use this image)
endif

PYGIT2_VERSION?=1.0.3

SALT_PASSWORD?=salt
SALT_USER?=salt
SALT_VERSION?=3000.1

define HELP_MENU
Usage: make [<env> ...] <target> [<target> ...]

Main targets:
  help         show this help
  run          run the image using default arguments

Development targets:
  build        build the image
  debug        instanciate the image and spawn an interactive shell
  push         push the image to Docker Hub (credentials needed)
  save         save the image to an archive
  scratch      build the image from scratch

Refer to the documentation for use cases and examples.
endef

.PHONY: all build debug push run save scratch
.SILENT:

all: build

build:
	$(DOCKER_BINARY) build                                                   \
		--build-arg PYGIT2_VERSION=$(PYGIT2_VERSION)                         \
		--build-arg SALT_PASSWORD=$(SALT_PASSWORD)                           \
		--build-arg SALT_USER=$(SALT_USER)                                   \
		--build-arg SALT_VERSION=$(SALT_VERSION)                             \
		--file $(DOCKER_DOCKERFILE)                                          \
		--rm                                                                 \
		--tag $(DOCKER_REPOSITORY)/$(DOCKER_RESOURCE):$(DOCKER_RESOURCE_TAG) \
		$(DOCKER_BUILD_FLAGS)                                                \
		$(DOCKER_BUILD_CONTEXT)

debug:
	DOCKER_RUN_FLAGS+="--entrypoint=$(DOCKER_RUN_ENTRYPOINT) --interactive --tty" $(MAKE) run

help:
	$(info $(HELP_MENU))

push:
	$(DOCKER_BINARY) push    \
		$(DOCKER_PUSH_FLAGS) \
		$(DOCKER_REPOSITORY)/$(DOCKER_RESOURCE):$(DOCKER_RESOURCE_TAG)

run:
	$(DOCKER_BINARY) run                                               \
		--rm                                                           \
		$(DOCKER_RUN_FLAGS)                                            \
		$(DOCKER_REPOSITORY)/$(DOCKER_RESOURCE):$(DOCKER_RESOURCE_TAG) \
		$(DOCKER_RUN_CMD)

save:
	$(DOCKER_BINARY) save                                      \
		--output $(DOCKER_RESOURCE)-$(DOCKER_RESOURCE_TAG).tar \
		$(DOCKER_REPOSITORY)/$(DOCKER_RESOURCE):$(DOCKER_RESOURCE_TAG)

scratch:
	DOCKER_BUILD_FLAGS+=--no-cache $(MAKE) all
