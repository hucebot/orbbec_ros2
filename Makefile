# Variables
REGISTRY = registry.gitlab.inria.fr
IMAGE_NAME = hucebot/code/orbbec_ros2/orbbec_image
TAG = franka

.PHONY: login build-dev run build-dep deploy stop logs clean help

## login: Login to the GitLab registry
login:
	docker login $(REGISTRY)

## build-dev: Build the dev image
build-dev:
	docker compose -f docker-compose.dev.yaml build

## run: Start interactive dev container
run:
	xhost +local:docker
	docker compose -f docker-compose.dev.yaml up -d
	docker exec -it orbbec_dev /bin/bash

## build-dep: Build and tag the production image
build-dep:
	docker compose -f docker-compose.yaml build
	docker tag orbbec_ros2:latest $(REGISTRY)/$(IMAGE_NAME):$(TAG)

## deploy: Start the production container in background
deploy:
	docker compose -f docker-compose.yaml up -d --force-recreate
	@echo "Deployment started. Use 'make logs' to see the camera output."

## logs: Follow live logs from the deployment container
logs:
	docker compose -f docker-compose.yaml logs -f

## stop: Stop all containers
stop:
	docker compose -f docker-compose.dev.yaml stop
	docker compose -f docker-compose.yaml stop

## clean: Remove all local ROS2 build artifacts and docker containers
clean:
	docker compose -f docker-compose.dev.yaml down --remove-orphans
	docker compose -f docker-compose.yaml down --remove-orphans
	rm -rf build/ install/ log/
	@echo "Cleanup complete."

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^##' Makefile | sed -e 's/## //g' -e 's/: /:	/g'