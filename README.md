# arp-scanner
A simple bash script to scan common networks with ARP requests to steal a found internal IP address, if DHCP does not automatically assign one on startup.

Dependent on [arp-scan](https://github.com/royhills/arp-scan).
This script could easily be modified to steal MAC addresses using [macchanger](https://github.com/alobbs/macchanger) if desired, which would be useful for bypassing MAC-based access control lists (ACLs).
