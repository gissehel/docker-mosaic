.PHONY: run build rm shell runshell
all: run

APP_NAME=ncsa-mosaic
CONTAINER_NAME=$(APP_NAME)
CONTAINER_SHELL_NAME=$(APP_NAME)-shell
IMAGE=local/$(APP_NAME)
MOUNTS_X11=-v /tmp/.X11-unix:/tmp/.X11-unix
MOUNTS=$(MOUNTS_X11)
ENVS_X11=-e DISPLAY=:0
ENVS=$(ENVS_X11)
DOCKER_OPTS=$(ENVS) $(MOUNTS)

rm:
	docker rm -f $(CONTAINER_NAME) || cd .

.built:
	make build

build:
	docker build -t $(IMAGE) .
	touch .built

run: rm .built
	docker run -d --rm $(DOCKER_OPTS) --name=$(CONTAINER_NAME) $(IMAGE)

shell:
	docker exec -ti $(CONTAINER_NAME) /bin/sh

runshell: data/built
	docker run -ti --rm $(DOCKER_OPTS) --name=$(CONTAINER_SHELL_NAME) $(IMAGE) /bin/sh

