echo "======================="
echo "Starting provisioning"
echo "======================="


echo "======================="
echo "
        ▄▄▄▄▄     ▄▄    ▄▄     ▄▄▄▄   ▄▄▄▄▄▄   
        ██▀▀▀██   ██    ██   ██▀▀▀▀█  ██▀▀▀▀█▄ 
        ██    ██  ██    ██  ██▀       ██    ██ 
        ██    ██  ████████  ██        ██████▀  
        ██    ██  ██    ██  ██▄       ██       
        ██▄▄▄██   ██    ██   ██▄▄▄▄█  ██       
        ▀▀▀▀▀     ▀▀    ▀▀     ▀▀▀▀   ▀▀ 
"
echo "======================="

apt-get update
apt-get install -y isc-dhcp-server

mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bkp
cp /vagrant_config/DHCP/dhcpd.conf /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart

echo "======================="
echo "
        ▄▄▄▄▄     ▄▄▄   ▄▄    ▄▄▄▄   
        ██▀▀▀██   ███   ██  ▄█▀▀▀▀█  
        ██    ██  ██▀█  ██  ██▄      
        ██    ██  ██ ██ ██   ▀████▄  
        ██    ██  ██  █▄██       ▀██ 
        ██▄▄▄██   ██   ███  █▄▄▄▄▄█▀ 
        ▀▀▀▀▀     ▀▀   ▀▀▀   ▀▀▀▀▀   
"
echo "======================="

apt install -y bind9 bind9-doc bind9utils 

cp /vagrant_config/DNS/named.conf.options /etc/bind/named.conf.options
cp /vagrant_config/DNS/named.conf.local /etc/bind/named.conf.local

systemctl restart bind9

echo "======================="
echo "
        ▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄   
        ██▀▀▀▀▀▀  ▀▀▀██▀▀▀  ██▀▀▀▀█▄ 
        ██           ██     ██    ██ 
        ███████      ██     ██████▀  
        ██           ██     ██       
        ██           ██     ██       
        ▀▀           ▀▀     ▀▀   
"
echo "======================="

# Instalando o servidor FTP
apt-get install -y proftpd

# Criando o diretório a ser compartilhado

if ! [ -d "~/share" ]; then
    mkdir -p ~/share
    echo "Diretório /share criado"
else
    echo "Diretório /share já existe"
fi

# Criando o backup e movendo os arquivos de configuração
mv /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bkp
cp /vagrant_config/FTP/proftpd.conf /etc/proftpd/proftpd.conf

# Reiniciando o serviço
service proftpd restart

if ! id "webmaster" &>/dev/null; then
    useradd webmaster -d /root/share -s /bin/false
    echo "Usuário webmaster criado"
else
    echo "Usuário webmaster já existe"
fi

chown webmaster -R ~/share

echo "======================="
echo "
                       ▄▄▄▄                        ▄▄                 
                     ▄█▀▀▀▀█                       ██                 
                     ██▄        ▄█████▄  ████▄██▄  ██▄███▄    ▄█████▄ 
                      ▀████▄    ▀ ▄▄▄██  ██ ██ ██  ██▀  ▀██   ▀ ▄▄▄██ 
                          ▀██  ▄██▀▀▀██  ██ ██ ██  ██    ██  ▄██▀▀▀██ 
                     █▄▄▄▄▄█▀  ██▄▄▄███  ██ ██ ██  ███▄▄██▀  ██▄▄▄███ 
                      ▀▀▀▀▀     ▀▀▀▀ ▀▀  ▀▀ ▀▀ ▀▀  ▀▀ ▀▀▀     ▀▀▀▀ ▀▀ 

"
echo "======================="

# Instalando pacotes necessários para Samba
apt-get install -y libcups2 samba-common cups samba

# Backup e configuração do Samba
mv /etc/samba/smb.conf /etc/samba/smb.conf.bkp
cp /vagrant_config/SAMBA/smb.conf /etc/samba/smb.conf

# Criar grupo de usuários
groupadd users

# Criar diretórios compartilhados do Samba
for dir in /home/shares/allusers /home/shares/anonymous; do
    if ! [ -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Diretório $dir criado"
    else
        echo "Diretório $dir já existe"
    fi
done

# Definir permissões
chown -R root:users /home/shares/allusers/
chmod -R 0771 /home/shares/allusers/

chown -R root:users /home/shares/anonymous/
chmod -R 0771 /home/shares/anonymous/

# Criar usuário no Samba e configurar senha
USER="client"
SENHA="teste"
useradd -m -G users "$USER"
(echo "$SENHA"; echo "$SENHA") | smbpasswd -a "$USER" -s

# Reiniciar o serviço do Samba
systemctl restart smbd.service


echo "======================="
echo "                                                 
                        ██                        
                        ▀▀                        
 ██▄████▄   ▄███▄██   ████     ██▄████▄  ▀██  ██▀ 
 ██▀   ██  ██▀  ▀██     ██     ██▀   ██    ████   
 ██    ██  ██    ██     ██     ██    ██    ▄██▄   
 ██    ██  ▀██▄▄███  ▄▄▄██▄▄▄  ██    ██   ▄█▀▀█▄  
 ▀▀    ▀▀   ▄▀▀▀ ██  ▀▀▀▀▀▀▀▀  ▀▀    ▀▀  ▀▀▀  ▀▀▀ 
            ▀████▀▀                               
"
echo "======================="

apt install -y nginx

#Cria backup e move o arquivo de configuração para o local correto
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bkp
cp /vagrant_config/NginX/nginx.conf /etc/nginx/nginx.conf

#Altera permissões do arquivo de configuração
sudo chown root:root /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/nginx.conf


if ! [ -d "/var/www/example.com/" ]; then
    mkdir -p /var/www/example.com/
    echo "Diretório /var/www/example.com/ criado"
else
    echo "Diretório /var/www/example.com/ já existe"
fi

sudo chown -R www-data:www-data /var/www/example.com/
sudo chmod -R 755 /var/www/example.com/

echo "======================="
echo "                                                 
                        ██                        
                        ▀▀                        
 ██▄████▄   ▄███▄██   ████     ██▄████▄  ▀██  ██▀ 
 ██▀   ██  ██▀  ▀██     ██     ██▀   ██    ████   
 ██    ██  ██    ██     ██     ██    ██    ▄██▄   
 ██    ██  ▀██▄▄███  ▄▄▄██▄▄▄  ██    ██   ▄█▀▀█▄  
 ▀▀    ▀▀   ▄▀▀▀ ██  ▀▀▀▀▀▀▀▀  ▀▀    ▀▀  ▀▀▀  ▀▀▀ 
            ▀████▀▀                               
"
echo "======================="

apt-get install -y nfs-common nfs-kernel-server

#Cria backup e move o arquivo de configuração para o local correto.

mv /etc/default/nfs-common /etc/default/nfs-common.bkp
cp /vagrant_config/NFS/nfs-common /etc/default/nfs-common

#configuração Ponto de montagem.
mv /etc/exports /etc/exports.bkp
cp /vagrant_config/NFS/exports /etc/exports

#Logo apos configurar o exports Utilizar esse comando para exporta o arquivo.

exportfs -r

#Apos criar e compartilhar reinicie o servico

services nfs-common restart
services nfs-kernel-server restart

