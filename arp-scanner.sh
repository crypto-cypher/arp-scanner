#!/bin/bash

# Variables
wireless_int="wlp2s0"
wired_int="wlp2s0"
wireless_ip="$(ifconfig $wireless_int 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')"

# Check if IP is assigned to variable interface
if [[ $wireless_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Interface received IP address: $wireless_ip, DHCP is probably working"
else
        echo "Interface has no IP address, DHCP is probably not working"

        # Create log file
        rm slog.txt;touch slog.txt

        bandwidth="100000"

        # Common network ranges
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 192.168.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 192.168.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 192.168.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 172.16.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 172.16.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 172.16.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=wlp2s0 10.0.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 10.0.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan -g -B $bandwidth --interface=$wired_int 10.0.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
fi
