#!/bin/bash
echo "Please enter the name for your keys:"
read keyname
if [ "$1" = "--gen" ]; then
	openssl req -new -x509 -newkey rsa:2048 -keyout $keyname.keyout -outform DER -out $keyname.der -nodes -days 36500 -subj "/CN=$keyname/"
	mokutil --import $keyname.der
	echo "Please reboot your system and enroll MOK"
elif [ "$1" = "--sign" ]; then
	echo "signing key..."
	/usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./$keyname.keyout ./$keyname.der $(modinfo -n vboxdrv)
	/usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./$keyname.keyout ./$keyname.der $(modinfo -n vboxnetflt)
	/usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./$keyname.keyout ./$keyname.der $(modinfo -n vboxnetadp)
	/usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./$keyname.keyout ./$keyname.der $(modinfo -n vboxpci)
fi

