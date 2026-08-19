#!/bin/bash
set -e

sudo apt-get update

sudo apt-get install -y curl tar

XPACK_VERSION=$(curl -sI https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/latest \
  | grep -i '^location:' | grep -oP '/v\K[^\r\n]+')
XPACK_URL="https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v${XPACK_VERSION}/xpack-riscv-none-elf-gcc-${XPACK_VERSION}-linux-x64.tar.gz"

curl -L "$XPACK_URL" -o xpack-riscv-none-elf-gcc.tar.gz
sudo tar xf xpack-riscv-none-elf-gcc.tar.gz --strip-components=1 -C /usr/local/
rm xpack-riscv-none-elf-gcc.tar.gz