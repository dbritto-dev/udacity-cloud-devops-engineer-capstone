#!/usr/bin/env bash

# Step 1: Authenticate
docker login -u minorpatch

# Step 2: Push images
docker-compose push
