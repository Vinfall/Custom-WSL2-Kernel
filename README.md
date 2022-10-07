# Custom-WSL2-Kernel
Patch to build my own custom [WSL2-Linux-Kernel](https://github.com/microsoft/WSL2-Linux-Kernel).

## Usage

1. Backup config and generate patch that will be used later:

```sh
cp Microsoft/config-wsl ~/ms-config-wsl-5.15.62.1.config
cp .config ~/dm-crypt-plus-usb-kernel.config
diff -u ms-config-wsl-5.15.62.1.config dm-crypt-plus-usb-kernel.config > ~/dm-crypt-plus-usb.patch
```

2. How to use patch:

```sh
cp Microsoft/config-wsl ~/ms-config-wsl-5.15.68.1.config
# Change file name in line 1 (and optionally, timestamp)
vim ~/dm-crypt-plus-usb.patch
patch ~/ms-config-wsl-5.15.68.1.config < ~/dm-crypt-plus-usb.patch
cp ~/ms-config-wsl-5.15.68.1.config .config
```

3. Make sure we are safe by comparing with current custom kernel config:

```sh
cp /proc/config.gz config.gz
gunzip config.gz
diff config .config
```

4. The output should be like:

```sh
3c3
< # Linux/x86 5.15.62.114514 Kernel Configuration
---
> # Linux/x86 5.15.68.114514 Kernel Configuration
```

5. (Optional) If anything goes wrong, just revert the patch:

```sh
patch -R .config < ~/dm-crypt-plus-usb.patch
```

You may check out my blog 
[Linux From Scratch (LFS) 编译记录](https://blog.vinfall.com/posts/2022/lfs)
(written in Chinese, but most comments are in English) on this for details.
