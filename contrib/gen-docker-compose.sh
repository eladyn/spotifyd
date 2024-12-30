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
    image: debian:bookworm
    platform: $platform
    command: bash -c "
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default --default-toolchain stable -y &&
        apt-get update &&
        apt-get install -y ${dependencies[*]} &&
        cargo build --release --no-default-features --features $features"
    working_dir: /build
    volumes:
      - ./:/build
END_FILE
