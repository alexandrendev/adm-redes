echo "======================="
echo "Starting provisioning"
echo "======================="


echo "======================="
echo "
 ____  _   _  ____ ____  
|  _ \| | | |/ ___|  _ \ 
| | | | |_| | |   | |_) |
| |_| |  _  | |___|  __/ 
|____/|_| |_|\____|_| 
"
echo "======================="

apt-get update
apt-get install -y isc-dhcp-server

mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bkp
cp /vagrant_config/DHCP/dhcpd.conf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart


echo "======================="
echo "
 _____ _____ ____  
|  ___|_   _|  _ \ 
| |_    | | | |_) |
|  _|   | | |  __/ 
|_|     |_| |_|    

"
echo "======================="

# Instalando o servidor FTP
apt-get install -y proftpd

# Criando o diretório a ser compartilhado
mkdir ~/share

# Criando o backup e movendo os arquivos de configuração
mv /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bkp
cp /vagrant_config/FTP/proftpd.conf /etc/proftpd/proftpd.conf

# Reiniciando o serviço
service proftpd restart

useradd webmaster -d ~/share -s /bin/false

chown webmaster -R ~/share