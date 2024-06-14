echo adding the iptables rules to the new container

# Enable Suricata iptable rules eth1

sudo docker exec IDS /bin/bash -c "iptables -I FORWARD -i eth1 -j NFQUEUE"

# Enable Suricata iptable rules eth2

sudo docker exec IDS /bin/bash -c "iptables -I FORWARD -i eth2 -j NFQUEUE"

# Enable Suricata iptable rules eth3

sudo docker exec IDS /bin/bash -c "iptables -I FORWARD -i eth3 -j NFQUEUE"

# Enable Suricata iptable rules eth4

sudo docker exec IDS /bin/bash -c "iptables -I FORWARD -i eth4 -j NFQUEUE"

# Enable Suricata iptable rules eth5

sudo docker exec IDS /bin/bash -c "iptables -I FORWARD -i eth5 -j NFQUEUE"

# Adding iptables persistent 

sudo docker exec IDS /bin/bash -c "apt-get install iptables-persistent -y"

# Saving iptables file

sudo docker exec IDS /bin/bash -c "iptables-save > /etc/iptables.conf"

# Update the Buildstamp file

sudo echo UNS_Sensor-v1.1.5-06142024 > /etc/buildstamp