# Custom-WSL2-Kernel

Patch to build my own custom [WSL2-Linux-Kernel](https://github.com/microsoft/WSL2-Linux-Kernel).

## Benefits

- Native-CPU Optimized (via make flag `CFLAGS='-march=native -O2 -pipe'`)
- [USB Support](https://dowww.spencerwoo.com/4-advanced/4-4-usb.html) (WSL has partial native support now)
- [Enable extra cryptos for DM-Crypt](https://gist.github.com/d4v3y0rk/e19d346ec9836b4811d4fecc1e1d5d64?permalink_comment_id=4314492#gistcomment-4314492), which makes mounting [VeraCrypt](https://veracrypt.fr/en/Home.html) volumes inside WSL possible
- Make sure the source code released by Microsoft is really functional
- Add whatever you like in the kernel name, which would later be reflected in [Neofetch](https://github.com/dylanaraps/neofetch) or [screenFetch](https://github.com/KittyKatt/screenFetch)

## Usage

### Customization

Check [latest releases](https://github.com/Vinfall/Custom-WSL2-Kernel/releases/latest) for patched make config to customize it yourself.

### Kernel

> [!TIP]
> Remember to **replace the version number** with the latest!

1. Backup config and generate patch that will be used later, run in unpacked WSL kernel directory:

```sh
# Change version
KERNEL_VER="5.15.150.1"
# Backup config
cp Microsoft/config-wsl $HOME/linux-msft-wsl-${KERNEL_VER}.config
cp .config $HOME/dm-crypt-plus-usb-kernel.config
# Geterante patch
TZ=UTC diff -u Microsoft/config-wsl .config > $HOME/dm-crypt-plus-usb.patch
unset KERNEL_VER
```

2. How to use patch:

```sh
cp Microsoft/config-wsl .config
patch .config < dm-crypt-plus-usb.patch
```

3. Make sure we are safe by comparing with current custom kernel config (if you use my config previously):

```sh
cp /proc/config.gz config.gz
gunzip config.gz
diff config .config
```

4. The output should be something like:

```sh
3c3
< # Linux/x86 5.15.62.114514 Kernel Configuration
---
> # Linux/x86 5.15.68.114514 Kernel Configuration
```

5. (Optional) If anything goes wrong, just revert the patch:

```sh
patch -R .config < dm-crypt-plus-usb.patch
```

6. Create `.wslconfig` in `%USERPROFILE%` to replace the WSL kernel without replacing `$Env:SystemRoot\System32\lxss\tools\kernel`.

```ini
[wsl2]
kernel=C:\\WSL\\bzImage
```

### USBIP

Only do this after you have compiled the kernel,
and make sure you are inside the kernel root folder.
This will compile and copy the necessary library to the system,
you may want to backup `libusbip.so.0` to reuse it on other distros.

```sh
# Compile USBIP
cd tools/usb/usbip
bash ./autogen.sh
bash ./configure
make install
# Make USBIP toolchain accessible by USBIP
cp libsrc/.libs/libusbip.so.0 /lib/libusbip.so.0
# Backup USBIP & config
cp libsrc/.libs/libusbip.so.0 /mnt/c/WSL/libusbip.so.0
cd ../../../
cp .config /mnt/c/WSL/dm-crypt-plus-usb-kernel.config
cp dm-crypt-plus-usb.patch /mnt/c/WSL/dm-crypt-plus-usb.patch
```

You may check out my blog 
[Linux From Scratch (LFS) 编译记录](https://blog.vinfall.com/posts/2022/09/lfs/)
(written in Chinese, but most comments in code blocks are in English) on this for details.
