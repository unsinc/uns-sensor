#!/bin/bash
ps -ef | grep suricata | grep -v grep
if [ $? -eq 0 ]; then
  echo "Process is running."
else
  sudo docker exec IDS /bin/bash -c "service suricata start"
fi
