#!/bin/bash
ifaces=$(ip -br link | grep -v lo | cut -d " " -f 1)
function print_help {
	echo "Usage:
$./interfaces.sh -h|help	Displays this Help Text
$./interfaces.sh [IFACE] [IP ADDR/MASK] [GATEWAY]
$./interfaces.sh eth0 192.168.1.1/24 192.168.1.254   | Remove ip configuration over all the NICs and set to eth0 an ip address and provides a gateway	
	
"
	exit 0
}
if [ $# -eq 0 ]
then
	print_help
fi
if [ $1 == "-h" ] || [ $1 == "help" ]
then
	print_help
fi
if [ $# -gt 1 ] && [ $# -lt 3 ]
then
	echo "Arguments missing, check syntax on ./interfaces.sh help"
	exit 0
fi
iface_gw=$1
ip_addr=$2
gw=$3

function config_iface {
	ip addr add $ip_addr dev $iface_gw
	if [ $? -ne 0 ]
	then
		echo "ip address configuration not valid. Check help and Try again"
		exit 0
	fi
	ip route add default via $gw
	if [ $? -ne 0 ]
	then
		echo "Can not assign gateway. check help and Try again"
		exit 0
	fi
	echo "IP Configuration success"
	exit 0
}

function clean_ifaces {
	for iface in $ifaces
	do
		ip addr flush $iface
	done
	echo "Cleanning IP Configuration"
	sleep 1
}
clean_ifaces
config_iface

