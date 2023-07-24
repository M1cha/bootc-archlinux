# Arch Linux bootc container builder

As root:

```bash
./build
````

Current state:

```bash
# podman run --privileged --pid=host --net=none --security-opt label=type:unconfined_t bootc-arch bootc install --target-no-signature-verification /dev/sdb
Mounting devtmpfs
Initializing partitions
Creating filesystem
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem
Mounting /run/bootc/mounts/rootfs
Mounting /run/bootc/mounts/rootfs/boot
Creating ESP filesystem
Mounting /run/bootc/mounts/rootfs/boot/efi
Initializing ostree layout
Initializing sysroot
ostree/deploy/default initialized as OSTree root
Creating initial deployment
ERROR Creating ostree deployment: Performing deployment: Importing: Unencapsulating base: Importing commit: Expected commit object, not File
```
