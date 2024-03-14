# uns-sensor
 
_This is a repository that will create the uns-sensor when used with ansible-get_

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

1.  This will use PIP to install suricata-update on the main system
1.  This will create a new partition called sns that will be used for docker and the agent
1.  This will create a docker container called IDS to run Suricata and configure the remaining 5 ports as SPAN ports to the IDS container and the apprpriate server users
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
	1.  *This system will reboot itself if required by the updates @ 08:00 UTC*
1.  There are several files downloaded to the system to help condifure the IDS container or in prerperation for multi-tenancy use in Surcata
	- As of right now I am not able to get multi-tenancy to function in Suricata usng the device command.  So all SPAN interfaces are using the same main suricata.yaml file. 
	- The additioanl eth<#>.yampl files are in preperation for multi-tenancy
