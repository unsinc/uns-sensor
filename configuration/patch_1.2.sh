#!/bin/bash
# Stop and delete the old IDS Sensor container
echo Stopping and deleting the old IDS contaner

sudo docker stop IDS & pid0=$!

wait $pid0

sudo docker remove IDS & pid1=$!

wait $pid1

# Remove the old suricata container image
echo Removing the old IDS image

sudo docker image rm suricata & pid2=$!

wait $pid2

# Clear the old docker system chache

echo Clearing the old docker cache

sudo docker system prune -a -f & pid3=$!

wait $pid3

# Download the updated docker compose file
echo Downloading the new docker-compose file and dockerfile

sudo curl https://raw.githubusercontent.com/unsinc/uns-sensor/lab/configuration/docker-compose.yml -o /sns/docker/docker-compose.yml & pid4=$!

wait $pid4 

sudo curl https://raw.githubusercontent.com/unsinc/uns-sensor/lab/configuration/dockerfile -o /sns/docker/dockerfile & pid5=$!

wait $pid5

# Create the new IDS container
echo Running docker compose

sudo docker compose -f /sns/docker/docker-compose.yml up -d & pid6=$!

wait $pid6

sudo curl https://raw.githubusercontent.com/unsinc/uns-sensor/lab/tasks/suricata -o /etc/logrotate.d/suricata & pid7=$!

wait $pid7

# Create the IDS interfaces
echo Recreating the IDS span_interfaces

cat /home/uns/span_interfaces.txt | while read line
do sudo docker network create -d macvlan -o macvlan_mode=passthru -o parent=$line $line'_span'
done

# Attach the SPAN interfaces to the container
echo attaching the SPAN interfaces

cat /home/uns/span_interfaces.txt | while read line
do sudo docker network connect $line'_span' IDS
done

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

# Enable suricata

sudo docker exec IDS /bin/bash -c "systemctl enable suricata"

# Start suricata

sudo docker exec IDS /bin/bash -c "service suricata start"

# Createa. Buildstamp file

sudo echo UNS_Sensor-v1.2.0-06142024 > /etc/buildstamp