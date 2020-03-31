#!/usr/bin/env make

ENVIRONMENT_FILE?=kickstart.env

-include $(ENVIRONMENT_FILE)

DOCKER_BINARY?=docker
DOCKER_BUILD_FLAGS+=
DOCKER_PUSH_FLAGS+=
DOCKER_REPOSITORY?=docker.io/sk4labs
DOCKER_TRACKING_LABEL?=com.github.sk4la.tracker

DOCKER_BUNDLE+=$(DOCKER_REPOSITORY)/salt:alpine
DOCKER_BUNDLE+=$(DOCKER_REPOSITORY)/dummy:ubuntu
DOCKER_BUNDLE_NAME?=bundle

ifndef DOCKER_BINARY
	$(error Docker (https://docs.docker.com/install/) is required. Please install it first)
endif

export DOCKER_BINARY
export DOCKER_BUILD_FLAGS
export DOCKER_PUSH_FLAGS
export DOCKER_REPOSITORY

DOCKER_COMPOSE_BINARY?=docker-compose
DOCKER_COMPOSE_FILE?=docker-compose.yml
DOCKER_COMPOSE_PROJECT?=sk4labs
DOCKER_COMPOSE_SCALE_COUNT?=1
DOCKER_COMPOSE_SCALE_PATTERN+=dummy=$(DOCKER_COMPOSE_SCALE_COUNT)

ifndef DOCKER_COMPOSE_BINARY
	$(error Docker Compose (https://docs.docker.com/compose/install/) is required. Please install it first)
endif

export DOCKER_COMPOSE_PROJECT
export DOCKER_COMPOSE_SCALE_COUNT

GZIP_BINARY?=gzip

PYGIT2_VERSION?=1.0.3

export PYGIT2_VERSION

SALT_PASSWORD?=salt
SALT_USER?=salt
SALT_ROOT?=/srv
SALT_SHELL?=ash
SALT_VERSION?=3000

export SALT_PASSWORD
export SALT_USER
export SALT_VERSION

TARGETS:=$(wildcard docker)

define HELP_MENU
Usage: make [<env> ...] <target> [<target> ...]

Main targets:
  down         bring the stack down
  help         show this help
  list         list containers in the stack
  ssh          spawn an interactive shell
  up           bring the stack up

Development targets:
  build        build all images
  bundle       save all images as a single archive
  push         publish all images to Docker Hub
  scratch      build all images from scratch

Refer to the documentation for use cases and examples.
endef

.PHONY: all build down help list push scratch ssh up $(TARGETS)
.SILENT:

all: up ssh

build push scratch: $(TARGETS)

bundle:
	$(DOCKER_BINARY) save $(DOCKER_BUNDLE) | $(GZIP_BINARY) > $(DOCKER_BUNDLE_NAME).tar.gz

down:
	$(DOCKER_COMPOSE_BINARY)                     \
		--file $(DOCKER_COMPOSE_FILE)            \
		--project-name $(DOCKER_COMPOSE_PROJECT) \
		$@

help:
	$(info $(HELP_MENU))

list:
	$(DOCKER_BINARY) container list --filter label=$(DOCKER_TRACKING_LABEL)

ssh:
	$(DOCKER_BINARY) exec                \
		--interactive                    \
		--tty                            \
		--user $(SALT_USER):$(SALT_USER) \
		--workdir $(SALT_ROOT)           \
		$(DOCKER_COMPOSE_PROJECT)_salt_1 $(SALT_SHELL)

up:
	$(DOCKER_COMPOSE_BINARY)                         \
		--file $(DOCKER_COMPOSE_FILE)                \
		--project-name $(DOCKER_COMPOSE_PROJECT)     \
		$@                                           \
		--detach                                     \
		--scale $(DOCKER_COMPOSE_SCALE_PATTERN)

$(TARGETS):
	$(MAKE) --directory $@ $(MAKECMDGOALS)
