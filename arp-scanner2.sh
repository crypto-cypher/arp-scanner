#!/bin/bash

# Variables - modify these for your system
wireless_int="wlan0"
wired_int="eth-br"
wireless_ip="$(ifconfig $wireless_int 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')"
verify_ip="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$"

# Check if IP is assigned to variable interface
if [[ $wireless_ip =~ $verify_ip; then
        echo "Interface received IP address: $wireless_ip, DHCP is probably working"
else
      	echo "Interface has no IP address, DHCP is probably not working"

	# Create log file
       	sudo touch slog.txt

        # Bandwidth decreased from default value to prevent ARP packet loss for optimal results, but slower
       	bandwidth="100000"
        fake_ip="192.168.50.5"
        
       	# Common network ranges, append output to log slog.txt log file
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 192.168.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 192.168.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 192.168.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 192.168.10.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 172.16.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 172.16.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 172.16.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 172.16.10.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
        sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 10.0.0.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 10.0.1.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 10.0.2.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
       	sudo arp-scan --arpspa $fake_ip -g -B $bandwidth --interface=$wired_int 10.0.10.0/24 |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt

	# Set static IP to X.X.X.250. Uses last network found in log file because scanned results are appended to slog.txt
	sudo ifconfig $wired_int $(tail -1 slog.txt | cut -d"." -f1,2,3).250/24 up
fi
