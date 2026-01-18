# Documentation of the FTP Project

Here i explain what i did in the files to make the server works. The system is a Debian 12 with vsftpd.

## 1. The Vagrantfile
In this file is the config of the Virtual Machine. I changed this things:

* **Box:** I used `debian/bookworm64` becouse is the version 12 of Debian.
* **Hostname:** I put `mirror.sistema.sol` like the exercise ask.
* **Network:** I put a private IP `192.168.56.10`. This is important to connect from my real computer to the virtual machine.
* **Provision:** I tell vagrant to look for the scrip in the folder `provision/provision.sh`.

## 2. The Provision Script [(provision.sh)]
This script run automaticly when the machine starts. I did this steps inside:

1. **Install:** First i run `apt-get update` and install the package `vsftpd`.
2. **Backup:** I copy the original config file to `.bak` just in case.
3. **Configuration:** I rewrite the file `/etc/vsftpd.conf` with the rules needed.

### Specific configs i put in the file:
* `listen=YES`: To use IPv4 only.
* `anonymous_enable=YES`: To let anonimous users enter.
* `local_enable=NO`: To block local users (security).
* `write_enable=NO`: No one can write or upload files.
* `ftpd_banner`: The welcome message when you conecct.
* `dirmessage_enable=YES`: To show the special message file.
* `max_clients=200`: Limit of conections.
* `anon_max_rate=51200`: Speed limit of 50KB (bytes).
* `idle_session_timeout=30`: Disconnect if user dont do nothing for 30 seconds.

4. **The Message File:** I created the file `/srv/ftp/.message` with the text about rules. This file appears when user enter the directory.
5. **Restart:** Finally i restart the service `vsftpd` to apply changes.