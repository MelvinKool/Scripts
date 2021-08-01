#!/bin/bash
keyname="MOK"
if [ "$1" = "--gen" ]; then
	openssl req -x509 -new -nodes -utf8 -sha256 -days 36500 -batch -config openssl.cnf -outform DER -out "$keyname.der"  -keyout "$keyname.priv"
	mokutil --import "$keyname.der"
	echo "Please reboot your system and enroll MOK"
elif [ "$1" = "--sign" ]; then
	echo "signing key..."
	# VirtualBox
	"/usr/src/kernels/$(uname -r)/scripts/sign-file" sha256 "./$keyname.keyout" "./$keyname.der" "$(modinfo -n vboxdrv)"
	"/usr/src/kernels/$(uname -r)/scripts/sign-file" sha256 "./$keyname.keyout" "./$keyname.der" "$(modinfo -n vboxnetflt)"
	"/usr/src/kernels/$(uname -r)/scripts/sign-file" sha256 "./$keyname.keyout" "./$keyname.der" "$(modinfo -n vboxnetadp)"
	"/usr/src/kernels/$(uname -r)/scripts/sign-file" sha256 "./$keyname.keyout" "./$keyname.der" "$(modinfo -n vboxpci)"
	# VMWare
	"/usr/src/kernels/$(uname -r)/scripts/sign-file" sha256 "./$keyname.keyout" "./$keyname.der" "$(modinfo -n vmmon)"
	"/usr/src/kernels/$(uname -r)/scripts/sign-file" sha256 "./$keyname.keyout" "./$keyname.der" "$(modinfo -n vmnet)"
fi

