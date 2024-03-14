# uns-sensor
 
## This is a repository that will install the uns-sensor when used with ansible-get

### Run the command ```sudo ansible-pull -U https://github.com/unsinc/uns-sensor.git``` to have the following done on the system:

1.  This will install the following packages onto an Ubuntu/Debian System
  - auditd
  - htop
  - nano
  - psmisc
  - net-tools
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin
  - python3-pip

1.  This will use PIP to install suricata-update on the host
1.  This will create a new partition called sns that will be used for docker and the agent
1.  This will create a docker container called IDS to run Suricata and configure the remaining 5 ports as SPAN ports for the IDS container
1.  This will create the appropriate system users needed for ansible, docker, and suricata
1.  Several Cron Jobs are added to keep the Suricata rules current
	-  Sensor Configuration: @ Every Hour at 10 after the hour every day
	-  Starting Suricata: @ Startup or Reboot after 2 minutes
	-  Update the Surcata Rule Sources: @ 12:00 UTC every day   
	-  Update the Suricata Rules: @ 12:05 UTC every day
	-  Migrate the suricata rules to the suricata directory: @ 12:30 UTC every day
	-  Restart the Suricata Service to apply the new rules: @ 12:45 UTC every day

1.  The following Suricata Rules Sources are enabled for use in the IDS container
	- oisf/trafficid
    - sslbl/ssl-fp-blacklist
    - sslbl/ja3-fingerprints
    - etnetera/aggressive
    - tgreen/hunting
    - malsilo/win-malware
	- pawpatrules    

1.  The system looks to keep itself up-to-date with security updates
	-  **This system will reboot itself if required by the updates @ 08:00 UTC**
1.  There are several files downloaded to the system to help condifure the IDS container or in prerperation for multi-tenancy use in Suricata
	- As of right now I am not able to get multi-tenancy to function in Suricata usng the device command.  So all SPAN interfaces are using the same main suricata.yaml file. 
	- The additional eth<#>.yaml files are in preperation for multi-tenancy
1.  The agent will be installed manually on the sns partition oafter the initial ansible-pull has been run