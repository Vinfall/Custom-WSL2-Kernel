#!/bin/bash

KERNEL_VER="5.15.150.1"

# Get latest tarball
wget "https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-${KERNEL_VER}.tar.gz"
tar xf linux-msft-wsl-${KERNEL_VER}.tar.gz
cd WSL2-Linux-Kernel-linux-msft-wsl-${KERNEL_VER} || exit
unset KERNEL_VER

# Patch
cp Microsoft/config-wsl .config
patch .config < dm-crypt-plus-usb.patch

# Compile kernel
make
mkdir output
cp arch/x86/boot/bzImage output/"$(date +'%Y%m%d')"-bzImage
# Compile USBIP
cd tools/usb/usbip || exit
./autogen.sh
./configure
make install
cp libsrc/.libs/libusbip.so.0 output/libusbip.so.0

