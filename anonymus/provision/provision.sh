
echo "Instalando vsftpd..."
apt-get update
apt-get install -y vsftpd


cp /etc/vsftpd.conf /etc/vsftpd.conf.bak


cat <<EOF > /etc/vsftpd.conf



listen=YES
listen_ipv6=NO

# --- Mensaje de Bienvenida del Servidor (Banner inicial) ---
ftpd_banner=-- Mirror de Opensuse para 'sistema.sol'


anonymous_enable=YES


local_enable=NO


write_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO

dirmessage_enable=YES



max_clients=200


anon_max_rate=51200


idle_session_timeout=30


EOF

# 4. Crear el fichero de mensaje (.message)
# Este fichero se muestra al usuario al loguearse o entrar al directorio.
cat <<EOF > /srv/ftp/.message
--
-- Servidor anónimo
-- Máximo de 200 conexiones activas simultáneas.
-- Ancho de banda de 50KB por usuario
-- Timeout de inactividad de 30 segundos
--
EOF


dd if=/dev/zero of=/srv/ftp/test_speed_100MB.iso bs=1M count=100 status=progress


systemctl restart vsftpd

