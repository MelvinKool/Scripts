#!/bin/bash
if [ $EUID -ne 0 ]; then
	echo "Script should run as root, exiting..."
	exit 126
fi
wpaconffile="/etc/wpa_supplicant/wpa_supplicant.conf"
interfaces=$(ifconfig -a -s |  awk '{print $1;}' | tail -n +3)
getInterface() {
	echo -e "Available interfaces:\n$interfaces"
	interfaceFound=0
	while [ $interfaceFound -ne 1 ]; do
		read -p "Interface: " interface
		if [ -z "$interface" ]; then
			continue
		fi
		for i in "${interfaces[@]}"; do
			if [ $i = $interface ]; then
				interfaceFound=1
				break
			fi
		done
		if [ $interfaceFound -eq 0 ]; then
			echo "Interface does not exist, please enter a valid interface."
		fi
	done
}
if [ ${#interfaces[@]} -gt 1 ]; then
	getInterface
else
	interface=${interfaces[0]}
fi
interfacesUp=$(ifconfig -s |  awk '{print $1;}' | tail -n +3)
interfaceUp=0
echo $interfacesUp

if [ -z $interfacesUp ]; then
	ifconfig $interface up
else
	for i in "${interfacesUp[@]}"; do
		if [ $i = $interface ]; then
			interfaceUp=1
			break
		fi
	done
	if [ $interfaceUp -eq 0 ]; then
		ifconfig $interface up
	fi
fi
essids=$(iwlist $interface scanning | grep -o 'ESSID:".*"' | sed 's/ESSID:"\(.*\)"/\1/')
if [ ${#essids[@]} -eq 0 ]; then
	echo "No ESSIDS found :(, exiting..."
	exit 0
fi
echo -e "Found ESSIDS:\n$essids"
for essid in ${essids[@]}; do
	if grep -q $essid $wpaconffile; then
		echo "Connecting to $essid..."
		wpa_supplicant -B -i $interface -c $wpaconffile
		sleep 1
		dhclient -r
		dhclient $interface
		break
	fi
done

