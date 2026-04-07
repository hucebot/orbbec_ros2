# Load environment variables from .env
-include .env
export

# Fallback tag if CAMERA_NAME isn't set in .env
TAG ?= $(CAMERA_NAME)

.PHONY: login build deploy stop logs clean help install-udev list-devices rviz attach

## login: Login to the container registry defined in .env
login:
	@if [ -z "$(REGISTRY)" ]; then echo "REGISTRY not defined in .env"; exit 1; fi
	docker login $(REGISTRY)

## build: Build the production image (and tag it if REGISTRY and IMAGE_NAME are set in .env)
build:
	docker compose -f docker-compose.yaml build
	@if [ -n "$(REGISTRY)" ] && [ -n "$(IMAGE_NAME)" ]; then \
		docker tag orbbec_ros2:latest $(REGISTRY)/$(IMAGE_NAME):$(TAG); \
		echo "Tagged image as $(REGISTRY)/$(IMAGE_NAME):$(TAG)"; \
	else \
		echo "REGISTRY or IMAGE_NAME not found in .env. Skipping remote tagging."; \
	fi

## deploy: Start the production container in background
deploy:
	docker compose -f docker-compose.yaml up -d --force-recreate
	@echo "Deployment started for camera: $(CAMERA_NAME). Use 'make logs' to view."

## logs: Follow live logs from the deployment container
logs:
	docker compose -f docker-compose.yaml logs -f

## stop: Stop the deployment container
stop:
	docker compose -f docker-compose.yaml stop

## clean: Remove all local ROS 2 build artifacts and docker containers
clean:
	docker compose -f docker-compose.yaml down --remove-orphans
	rm -rf build/ install/ log/
	@echo "Cleanup complete."

## install-udev: Install host udev rules and increase USB buffer (requires sudo)
install-udev:
	@echo "Installing udev rules on the host..."
	sudo bash scripts/udev_rules.sh
	sudo sh -c 'echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb'

## list-devices: List all connected Orbbec USB devices
list-devices:
	bash scripts/list_devices.sh

## rviz: Launch RViz2 attached to the running deployment container for debugging
rviz:
	@echo "Opening RViz2... (Ensure the container is running via 'make deploy')"
	xhost +local:docker
	docker exec -it orbbec_deploy /entrypoint.sh rviz2

## attach: Open an interactive bash shell inside the running deployment container
attach:
	@echo "Attaching interactive shell to 'orbbec_deploy'..."
	docker exec -it orbbec_deploy /entrypoint.sh bash

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^##' Makefile | sed -e 's/## //g' -e 's/: /:	/g'


