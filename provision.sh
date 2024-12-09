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
#
#
#
#
#
#
#
#
#
#
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
