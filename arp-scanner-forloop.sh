#!/bin/bash
# A simple bash script to scan common networks with ARP requests to steal a found internal IP address, if DHCP does not automatically assign one.
# Only works on wired connections - must be connected to network via Ethernet, even if no IP is assigned, not for wireless
# Startup script on Linux systems

# Sleep for 15 seconds before executing, this way DHCP client has time to try to do it's thang
sleep 15

# Variables - modify wired_int for your system's interface requiring an IP address
wired_int="eth0"
wired_ip="$(ifconfig $wired_int 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')"
verify_ip="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$"

# Check if IP is assigned to variable interface
if [[ $wired_ip =~ $verify_ip ]]; then
        echo "Interface received IP address: $wired_ip, DHCP is probably working"
else
      	echo "Interface has no IP address, DHCP is probably not working"

	# Create log file
       	sudo touch slog.txt

        # Bandwidth decreased from default value to prevent ARP packet loss for optimal results, but slower
       	bandwidth="100000"
        fake_ip="192.168.50.5"

       	# Common network ranges, append output to slog.txt log file
	declare -a scan_networks=("192.168.0.0/24,192.168.1.0/24,192.168.2.0/24,192.168.10.0/24,172.16.0.0/24,172.16.1.0/24,172.16.2.0/24,172.16.10.0/24,10.0.0.0/24,10.0.1.0/24,10.0.2.0/24,10.0.10.0/24")

	for ip in "${scan_networks[@]}"
	do
		sudo arp-scan --arpspa $fake_ip -g -B $bandwidth -I=$wired_int $ip |grep -P '^\d+(\.\d+){3}\s'|tee -a slog.txt
	done

	# Set static IP to X.X.X.250. Uses last network found in log file because scanned results are appended to slog.txt
	sudo ifconfig $wired_int $(tail -1 slog.txt | cut -d"." -f1,2,3).250/24 up
fi
