#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage $0 <platform> [features]"
  exit 1
fi

platform="$1"
features="$2"

if [ -z "$features" ]
then
  features="alsa_backend"
fi

dependencies=(libssl-dev pkg-config)

if [[ $features == *"alsa_backend"** ]]
then
  dependencies+=("libasound2-dev")
fi

cat << END_FILE
services:
  build-container:
    image: rust:bookworm
    platform: $platform
    command: bash -c "
        apt-get update &&
        apt-get install -y ${dependencies[*]} &&
        cargo build --release --no-default-features --features $features"
    working_dir: /spotifyd
    volumes:
      - ./:/build
END_FILE
