# FTP Server Documentacion

Here i explane the proces of the Secure FTP server practice with Vagran and Ansible.

## 1. The Vagrantfile Config
I modified the Vagrantfile to have 2 virtual machines.
* **Server Machine:** IP `192.168.56.10`. I map the port 2121 to 21 for Filezilla in my real PC. It uses Ansible.
* **Client Machine:** IP `192.168.56.20`. It also uses Ansible.

## 2. The Ansible Playbooks
I use YAML files in the `provision` folder. Is better than old scripts.

### The Server Playbook (`playbook_seguro.yml`)
This is the main config. I did this steps:
1. **Instal:** The task instal `vsftpd` and `openssl`.
2. **Users:** I created `luis` (is in jail), `maria` (is free) and `miguel`. I put passwords in the yaml.
3. **SSL Certificate:** I create a `.pem` file for the secure conect.
4. **Config:** I use the `copy` module for the `vsftpd.conf` file.
    * `ssl_enable=YES`: Security is active.
    * `force_local_logins_ssl=YES`: Users need encryption.
    * `chroot_local_user=YES`: For the jail.
5. **Jail Exception:** I put Maria in the `vsftpd.chroot_list` so she can go out of home.

### The Client Playbook (`playbook_cliente.yml`)
This prepares the client machine.
* Instal `ftp`, `curl` and `lftp` (necesary for SSL tests).
* It puts `192.168.56.10 ftp.example.test` in the hosts file.
* Create user `pepe` and a folder.

---

## 3. Commands Used in Console
The commands i used in the linux terminal:

* **`ftp 192.168.56.10`**: To check the Banner and Anonymous.
* **`lftp -u luis,luis 192.168.56.10`**: **IMPORTANT.** The normal `ftp` command gives **Error 530**. This is becose i force SSL for local users. 
* **`set ssl:verify-certificate no`**: Inside `lftp`, for the self-signed certificate.
* **`cd /etc`**: To test the Jail.
* **`wget ftp://192.168.56.10/test_speed.img`**: To check the speed limit.

---

## 4. Verification and Checks

Everything works:

1. **Banner:** I see "Welcome to system.sol" message.
2. **Jail Test:**
    * With **Luis**: He is in jail. `cd /etc` says "Access failed".
    * With **Maria**: She can go to `/etc`. She is free.
3. **Security:** If i use normal `ftp` with Luis, it dosent work. I need `lftp` or Filezilla with TLS.

---

## 5. Filezilla Screenshots

### A. Passive Mode
I conect with `anonymous`. In the log i see:
`227 Entering Passive Mode (192,168,56,10,X,Y)`.

### B. Secure Connection (SSL)
When i login with `luis`, Filezilla shows the certificate.

![cert](./img/filezilla_cert.png)

### C. The Lock Icon
The lock (candado) is closed. The conection is encripted.

![lock](./img/filezilla_lock.png)