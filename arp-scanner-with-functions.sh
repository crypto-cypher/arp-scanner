#!/bin/bash
# https://openwrt.org/packages/pkgdata/arp-scan
# If DHCP fails,
# ARP Scan 192.168.0.0/24, 192.168.1.0/24, 192.168.2.0/24, 172.16.0.0/24, 10.0.0.0/24, etc. -- could also fast scan /16 networks, and focus in from there
# If ARP Scan fails, passively listen for packets with Netdiscover, steal IP

# Variables
wireless_int="wlp2s0"
wired_int="wlp2s0"
wireless_ip="$(ifconfig $wireless_int 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')"

# Check if IP is assigned to variable interface
function check_ip()
{
	if [[ $wireless_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		return 1
	else
		return 0
	fi
}

# Zero knowledge ARP scan of common networks to discover IP to steal
function arp_scan()
{
	# Create log file
	rm slog.txt;touch slog.txt

	local bandwidth="100000"

	# Could do fast scan (only check .1 & .255 of ranges/subnets) with netdiscover... but we're using arp-scan, so no.
	# Common network ranges
	#sudo arp-scan -g -B $bandwidth --interface=$wired_int 192.168.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	#sudo arp-scan -g -B $bandwidth --interface=$wired_int 192.168.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	#sudo arp-scan -g -B $bandwidth --interface=$wired_int 192.168.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	#sudo arp-scan -g -B $bandwidth --interface=$wired_int 172.16.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	#sudo arp-scan -g -B $bandwidth --interface=$wired_int 172.16.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	#sudo arp-scan -g -B $bandwidth --interface=$wired_int 172.16.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	sudo arp-scan -B $bandwidth --interface=$wired_int -g 10.0.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	sudo arp-scan -B $bandwidth --interface=$wired_int -g 10.0.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	sudo arp-scan -B $bandwidth --interface=$wired_int -g 10.0.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt

	return 0
}

function main()
{
	if [[ "$(check_ip)" -eq 1 ]]; then
        	echo "Interface received IP address: $wireless_ip, DHCP is probably working"
		return 0
	elif [[ "$(check_ip)" -eq 0 ]]; then
      		echo "Interface has no IP address, DHCP is probably not working"
		arp_scan
		return 0
	fi
}

main
