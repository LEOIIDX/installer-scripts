#/bin/sh

#Gentoo installer script (DOS boot version)
#start after disks have been setup

ntpd -q -g

cd /mnt/gentoo

wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20210620T214504Z/stage3-amd64-systemd-20210620T214504Z.tar.xz
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

nano -w /mnt/gentoo/etc/portage/make.conf

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

mkdir --parents /mnt/gentoo/etc/portage/repos.conf

cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

cat /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev

chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

mount /dev/sda1 /boot

emerge-webrsync
emerge --sync

eselect profile list
echo "Enter Desired Profile"
read profile
eselect profile set $profile

emerge --verbose --update --deep --newuse @world
emerge app-portage/gentoolkit
emerge app-admin/sudo
emerge app-misc/neofetch
emerge net-misc/networkmanager && etc-update && emerge net-misc/networkmanager

ln -sf ../usr/share/zoneinfo/America/Chicago /etc/localtime

nano -w /etc/locale.gen
locale-gen
eselect locale list
echo "Enter Default Locale"
read locale
eselect locale set $locale
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

emerge sys-kernel/gentoo-sources
eselect kernel set 1
ls -l /usr/src/linux

emerge  --autounmask sys-kernel/genkernel
etc-update
emerge  --autounmask sys-kernel/genkernel
nano -w /etc/fstab
genkernel all
ls /boot/vmlinu* /boot/initramfs*
emerge sys-kernel/linux-firmware

nano -w /etc/fstab

passwd

emerge --verbose sys-boot/grub:2
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit

cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
reboot
