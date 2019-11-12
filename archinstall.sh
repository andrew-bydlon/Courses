echo "Note that root priveleges are necessary."

lsblk -f

echo "Enter the device you would like to install to: "
echo "Note: This will be destructive!"
read MyDevice

sgdisk --zap-all $MyDevice
cgdisk $MyDevice

mkfs.fat -F32 ${MyDevice}1
mkfs.btrfs -F32 ${MyDevice}2
mount ${MyDevice}2 /mnt
btrfs subvol create root /mnt/
btrfs subvol create home /mnt/
btrfs subvol create var /mnt/
btrfs subvol create opt /mnt/
umount /mnt

mount -o compress=zstd,subvol=root ${MyDevice}2 /mnt
mkdir /mnt/home /mnt/boot /mnt/var /mnt/opt
mount -o compress=zstd,subvol=var ${MyDevice}2 /mnt/var
mount -o compress=zstd,subvol=opt ${MyDevice}2 /mnt/opt
mount -o compress=zstd,subvol=home ${MyDevice}2 /mnt/home
mount ${MyDevice}1 /mnt/boot

echo "Would you like to do a [m]inimal install, a [g]nome & i3 install, or [f]ull Andrew install?"
read InstallLevel

if [InstallLevel = 'm']; then
	pacstrap /mnt base base-devel
fi

if [InstallLevel = 'g']; then
	pacstrap /mnt base base-devel firefox gnome gnome-extra i3 emacs xorg feh scrot conky rxvt-unicode rxvt-unicode-terminfo alsa-utils acpi awesome-terminal-fonts redshift xdotool screen
fi

if [InstallLevel = 'f']; then
	pacman -Qqn | pacstrap /mnt -
fi

echo "Graphics? [n]vidia, [a]md, [i]ntel?"


genfstab -U /mnt >> /mnt/etc/fstab
cp /etc/mkinitcpio.conf /mnt/etc/

echo "You can now check the fstab for correctness.  Press Enter to continue"
read Pause

nano /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8 UTF-8" >> /etc/locale.conf

echo "Enter your computer's name"
read ComputerName

echo $ComputerName >> /etc/hostname
echo "127.0.0.1	localhost
::1		localhost
127.0.1.1	${ComputerName}.localdomain	${ComputerName}" >> /etc/hosts

mkinitcpio -P

echo "Enter your root pw"
read -s RootPW

passwd
expect "password: "
send "$RootPW"

Truth='y'

while [$Truth = 'y']; do
	echo "Enter a user name"
	read UserName

	useradd -m -g users -s /bin/bash $UserName
	echo "Enter a password for ${username}"
	read -s UserPW

	passwd $UserName
	expect "password: "
	send "$UserPW"

	echo "Would you like ${UserName} to be sudoed? [y/n]"
	read Sudoed

	if [Sudoed = 'y']; then
		echo "${UserName} ALL=(ALL) ALL" >> /etc/sudoers
	fi

	echo "Would you like to add another user account? [y/n]"
	read Truth
done

bootctl install

echo "default  arch
timeout  3
console-mode max
editor   no" >> /boot/loader/loader.conf


echo "[amd] or [intel]?"
read Proc

pacman -S ${Proc}-ucode

MyUUID=$(blkid -s UUID -o value ${MyDevice})

echo "title   Arch Linux
linux   /vmlinuz-linux
initrd  /${proc}-ucode.img
initrd  /initramfs-linux.img
options root=UUID=${MyUUID} rootflags=subvol=root nomodeset rw" >> /boot/loader/entries/arch.conf

exit

umount -R /mnt

echo "Finished!  Congrats!"

done