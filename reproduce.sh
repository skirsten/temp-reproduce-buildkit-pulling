#!/bin/bash

set -eo pipefail

# reproduced on moby/buildkit:master 6805940 68059406655653f5df4b35f5a4728d673920f166

# these images are public so the relevant parts should work without a token

base_image="ghcr.io/skirsten/tmp:base"
random_image="ghcr.io/skirsten/tmp:random"

# create a base image

buildctl build --frontend dockerfile.v0 --local context=base --local dockerfile=base \
  --import-cache type=registry,ref=$base_image \
  --export-cache type=inline \
  --output type=image,name=$base_image,push=true

# create a image with a random binary that is 1GB in size

buildctl build --frontend dockerfile.v0 --local context=random --local dockerfile=random \
  --import-cache type=registry,ref=$random_image \
  --export-cache type=inline \
  --output type=image,name=$random_image,push=true

buildctl prune

# add a random part to the image to simluate a not-yet existing image
combined_image="ghcr.io/skirsten/tmp:combined-$(uuid)"

# !!! this will download, unpack and prepare the cache for the whole 1 GB image...
# this will take forever

buildctl build --frontend dockerfile.v0 --local context=combined --local dockerfile=combined \
  --import-cache type=registry,ref=$combined_image \
  --export-cache type=inline \
  --opt build-arg:base_image=$base_image \
  --opt build-arg:append_image=$random_image \
  --output type=image,name=$combined_image,push=true
