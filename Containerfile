FROM ghcr.io/cgwalters/c9s-oscore AS oscore

FROM docker.io/archlinux:latest AS builder

RUN pacman --noconfirm -Sy arch-install-scripts ostree
RUN sed -i -e 's|^NoExtract.*||g' /etc/pacman.conf

RUN mkdir /newroot
RUN pacstrap -K /newroot base linux-zen linux-firmware ostree gptfdisk cryptsetup dosfstools xfsprogs

RUN mv /newroot/home /newroot/var/
RUN ln -s var/home /newroot/home

RUN mv /newroot/mnt /newroot/var/
RUN ln -s var/mnt /newroot/mnt

RUN rmdir /newroot/var/opt
RUN mv /newroot/opt /newroot/var/
RUN ln -s var/opt /newroot/opt

RUN mv /newroot/root /newroot/var/roothome
RUN ln -s var/roothome /newroot/root

RUN mv /newroot/srv /newroot/var/srv
RUN ln -s var/srv /newroot/srv

COPY ostree-0-integration.conf /newroot/usr/lib/tmpfiles.d/

COPY --from=oscore /usr/bin/bootc /newroot/usr/bin/
COPY --from=oscore /usr/lib/bootc /newroot/usr/lib/bootc

RUN mkdir -p /newroot/sysroot/ostree
RUN ln -s sysroot/ostree /newroot/ostree
RUN ostree --repo=/repo init --mode=bare
RUN ostree --repo=/repo commit --orphan --tree=dir=/newroot --no-xattrs

# WORKAROUND: ERROR Creating ostree deployment: Performing deployment: Importing: Unencapsulating base: Importing commit: Invalid path (no parent) .lock
RUN rm /repo/.lock

RUN mv /repo /newroot/sysroot/ostree/

FROM scratch
COPY --from=builder /newroot /
LABEL ostree.bootable="true"
