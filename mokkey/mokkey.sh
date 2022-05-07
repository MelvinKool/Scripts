#!/bin/bash
keyname="MOK"
SIGN_FILE="/usr/src/linux-obj/x86_64/default/scripts/sign-file"
OUT_DIR="."
PRIV_FILE="${OUT_DIR}/$keyname.priv"
DER_FILE="${OUT_DIR}/$keyname.der"

if [ "$1" = "--gen" ]; then
	openssl req -x509 -new -nodes -utf8 -sha256 -days 36500 -batch -config openssl.cnf -outform DER -out "$DER_FILE"  -keyout "$PRIV_FILE"
	mokutil --import "$DER_FILE"
	echo "Please reboot your system and enroll MOK"
elif [ "$1" = "--sign" ]; then
	echo "signing key..."
	# VirtualBox
	#"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n vboxdrv)"
	#"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n vboxnetflt)"
	#"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n vboxnetadp)"
	#"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n vboxpci)"
	# VMWare
	#"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n vmmon)"
	#"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n vmnet)"

	# NVIDIA
	"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n nvidia_drm)"
	"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n nvidia_modeset)"
	"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n nvidia_uvm)"
	"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n nvidia-peermem)"
	"$SIGN_FILE" sha256 "$PRIV_FILE" "$DER_FILE" "$(modinfo -n nvidia)"
fi
