# Installation

Currently, installation is fairly ambiguous since its currently not well tested.. 

Essentially, on a new NixOS host: 


## Installation Procedure
```sh
rm -rf /etc/nixos/* 
cd /etc/nixos 
git clone $REPO_URL .
```

### Assumptions
- hostname is `1enovo` and... you know which one...
- full disk encryption is required.
- target disk is: `/dev/sda` (builtin is `/dev/nvmen0`).
- swap: `16GB`.
- necessary packages are available (`nix develop`).

But nothing is that simple...

### "Burning" a (_Bootable_) USB stick.

Build the ISO image and link it to ./result:
```sh
nix build .#iso
```

Use `lsblk` (Linux) or `diskutils` (macOS) to identify the correct disk:

```sh
lsblk -o name,type,path
# NAME          TYPE  PATH
# sda           disk  /dev/sda    # <- this is our USB stick!
# └─sda1        part  /dev/sda1
# nvme0n1       disk  /dev/nvme0n1
```

Use `dd` to copy the built image to the target disk.

```sh
dd if=./result/iso/*.iso of=/dev/sda status=progress
# 896119296 bytes (896 MB, 855 MiB) copied, 321 s, 2.8 MB/s   1
# 1759232+0 records in
# 1759232+0 records out
# 900726784 bytes (901 MB, 859 MiB) copied, 323.9 s, 2.8 MB/s
sync            # forces the disk cache to write (this is the roughly equivant of "safely" in "safely eject")
eject /dev/sda  # fully eject the device.
```

### Formatting the Disk(s)

```sh
nix develop # wait for shell to start.

gdisk /dev/sda

cryptsetup luksFormat /dev/sda2
# enter a memorable secret/passpharse (used below)

cryptsetup open /dev/sda2 nixenc
# enter the memorable secret/passpharse (created above)

pvcreate /dev/mapper/nixenc

vgcreate vg /dev/mapper/nixenc

lvcreate -n swap -L 16GB vg

lvcreate -n root -l +100%FREE vg

mkfs.vfat -n boot /dev/sda1

mkswap /dev/mapper/vg-swap

swapon /dev/mapper/vg-swap

mkfs.btrfs -L root /dev/mapper/vg-root
```

### Installing NixOS

```sh
nix develop # wait for shell to start

cryptsetup open /dev/sda2  
# enter secret/passpharse at the prompt

lsblk -o name,type,mountpoint,uuid
# NAME          TYPE  MOUNTPOINT UUID
# sda           disk
# ├─sda1        part             8464-2F23
# └─sda2        part             1e4d0bda-3c3e-4652-9f6d-7090658ef4bb
#   └─nixenc    crypt            4XM4Du-NWbk-xgiC-QeMQ-ii3Q-A11c-PcdjUR
#     ├─vg-swap lvm              bc61204b-87fb-4d5a-8191-bf2b8f52fde4
#     └─vg-root lvm              f0f2e07f-fbd3-4ef0-8810-dbb68907b448
# nvme0n1       disk

test -d /mnt || mkdir /mnt       # this dir doesnt exist by default on some *nix systems
mount /dev/disk/by-uuid/f0f2e07f-fbd3-4ef0-8810-dbb68907b448 /mnt
mount /dev/disk/by-uuid/8464-2F23 /mnt/boot
swapon /dev/disk/by-uuid/bc61204b-87fb-4d5a-8191-bf2b8f52fde4

lsblk
# NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
# sda             8:0    1 119.5G  0 disk
# ├─sda1          8:1    1   500M  0 part  /mnt/boot
# └─sda2          8:2    1   119G  0 part
#   └─nixenc    254:0    0   119G  0 crypt
#     ├─vg-swap 254:1    0    16G  0 lvm   [SWAP]
#     └─vg-root 254:2    0   103G  0 lvm   /mnt
# nvme0n1       259:0    0 476.9G  0 disk

nixos-install --root /mnt --flake ".#1enovo" # may also want "--no-root-password"

nixos-enter   # optional, enter the NixOS install via chroot to verify things.

reboot
```
