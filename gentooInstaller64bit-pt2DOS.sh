#/bin/sh

#Gentoo installer script (DOS boot version)
#start after disks have been setup

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
emerge --autounmask-write net-misc/networkmanager
dispatch-conf
emerge net-misc/networkmanager

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

emerge  --autounmask-write sys-kernel/genkernel
dispatch-conf
emerge sys-kernel/genkernel
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
