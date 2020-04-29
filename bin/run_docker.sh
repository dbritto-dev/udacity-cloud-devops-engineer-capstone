#!/usr/bin/env bash

# Step 1:
# Build and starts images
docker-compose up -f /opt/capstone.io/etc/docker/docker-compose.yml --build

# Step 2:
# List docker images
docker-compose images
