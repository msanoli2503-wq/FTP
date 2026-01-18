#!/bin/bash
echo "--- Configurando CLIENTE ---"
apt-get update
apt-get install -y ftp curl

# Simular DNS
echo "192.168.56.10 ftp.example.test" >> /etc/hosts

# Usuario pepe
useradd -m -s /bin/bash pepe
echo "pepe:pepe" | chpasswd
# Crear directorio de pruebas
mkdir -p /home/pepe/pruebasFTP
echo "Datos de prueba" > /home/pepe/pruebasFTP/datos1.txt
chown -R pepe:pepe /home/pepe/pruebasFTP