#!/bin/bash


# 1. Instalación
apt-get update
apt-get install -y vsftpd openssl

# 2. Crear usuarios y archivos de prueba
# Luis (Enjaulado)
useradd -m -s /bin/bash luis
echo "luis:luis" | chpasswd
touch /home/luis/luis1.txt /home/luis/luis2.txt
chown luis:luis /home/luis/luis*.txt

# Maria (NO Enjaulada)
useradd -m -s /bin/bash maria
echo "maria:maria" | chpasswd
touch /home/maria/maria1.txt /home/maria/maria2.txt
chown maria:maria /home/maria/maria*.txt

# Miguel
useradd -m -s /bin/bash miguel
echo "miguel:miguel" | chpasswd

# 3. Crear Certificado SSL (Para la parte segura)
mkdir -p /etc/ssl/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/certs/example.test.pem \
    -out /etc/ssl/certs/example.test.pem \
    -subj "/C=ES/ST=Sevilla/L=Sevilla/O=IES/CN=ftp.example.test"

# 4. Configurar vsftpd.conf 
mv /etc/vsftpd.conf /etc/vsftpd.conf.bak

cat <<EOF > /etc/vsftpd.conf
# --- Configuración Base ---
listen=YES
listen_ipv6=NO
ftpd_banner=--- Welcome to the FTP server of 'sistema.sol'---

# --- Usuarios Anónimos ---
anonymous_enable=YES
anon_root=/srv/ftp
dirmessage_enable=YES
no_anon_password=YES
# Límites anónimos (2MB/s) y permisos
anon_max_rate=2097152
anon_upload_enable=NO
anon_mkdir_write_enable=NO

# --- Usuarios Locales ---
local_enable=YES
write_enable=YES
local_umask=022
# Límites locales (5MB/s)
local_max_rate=5242880

# --- Red y Timeouts ---
connect_from_port_20=YES
idle_session_timeout=720
max_clients=15

# --- JAULAS CHROOT (Enjaular a todos menos a la lista) ---
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
allow_writeable_chroot=YES

# --- SEGURIDAD SSL/TLS ---
ssl_enable=YES
rsa_cert_file=/etc/ssl/certs/example.test.pem
rsa_private_key_file=/etc/ssl/certs/example.test.pem
# Forzar cifrado a locales, opcional para anónimos
force_local_logins_ssl=YES
force_local_data_ssl=YES
allow_anon_ssl=YES
force_anon_logins_ssl=NO
force_anon_data_ssl=NO
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=YES
require_ssl_reuse=NO
EOF

# 5. Configurar excepciones de Jaula (Maria no está enjaulada)
echo "maria" > /etc/vsftpd.chroot_list

# 6. Mensaje de bienvenida anónimo
echo "---You have accessed the public directory server of 'sistema.sol'---" > /srv/ftp/.message

# 7. Crear archivo grande para probar velocidad
dd if=/dev/zero of=/srv/ftp/test_speed.img bs=1M count=50

systemctl restart vsftpd
