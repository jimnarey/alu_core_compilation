#!/bin/bash

qemu-system-aarch64 \
    -m 2048 \
    -smp 4 \
    -cpu cortex-a57 \
    -M virt \
    -nographic   \
    -pflash flash0.img   \
    -pflash flash1.img   \
    -drive if=none,file=ubuntu-16.04-server-cloudimg-arm64-uefi1.img,id=hd0   \
    -device virtio-blk-device,drive=hd0   \
    -drive if=none,id=cloud,file=cloud.img   \
    -device virtio-blk-device,drive=cloud   \
    -netdev user,id=user0 \
    -device virtio-net-device,netdev=user0 \
    -redir tcp:2222::22