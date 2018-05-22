#!/bin/bash

# Variables
wireless_int="enp0s31f6"
wired_int="enp0s31f6"
wireless_ip="$(ifconfig $wireless_int 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')"

# Check if IP is assigned to variable interface
if [[ $wireless_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Interface received IP address: $wireless_ip, DHCP is probably working"
else
      	echo "Interface has no IP address, DHCP is probably not working"

	# Create log file
       	sudo rm slog.txt;touch slog.txt

       	bandwidth="100000"

       	# Common network ranges
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 192.168.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 192.168.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 192.168.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 172.16.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 172.16.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 172.16.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 10.0.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 10.0.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa 192.168.50.5 -g -B $bandwidth --interface=$wired_int 10.0.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt

	# Set static IP
	sudo ifconfig $wired_int $(head -1 slog.txt | cut -d"." -f1,2,3).250/24 up
fi
