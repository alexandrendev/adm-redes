----------------

```bash
                                                  ▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄   
                                                  ██▀▀▀▀▀▀  ▀▀▀██▀▀▀  ██▀▀▀▀█▄ 
                                                  ██           ██     ██    ██ 
                                                  ███████      ██     ██████▀  
                                                  ██           ██     ██       
                                                  ██           ██     ██       
                                                  ▀▀           ▀▀     ▀▀   
```
--------------

# Configuração

 1. Para configurar esse serviço primeiro é preciso instalar o `proftpd` com o seguinte comando:
    
    ```bash
    apt-get install -y proftpd
    ```

2. Agora é necessário criar o diretório a ser compartilhado com o comando:
    
    ```bash
    mkdir -p <nome_do_diretorio>
    ```

3. Agora é preciso criar o backup do arquivo de configuração e copiar o arquivo para o caminho `/etc/proftpd/proftpd.conf`:
    ```bash
    mv /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bkp
    cp /vagrant_config/FTP/proftpd.conf /etc/proftpd/proftpd.conf
    ```
4. Por fim, você deve reiniciar o serviço, criar o usuário alterar as permissões do diretório compartilhado:

    ```bash
    service proftpd restart
    useradd webmaster -d /root/share -s /bin/false
    chown webmaster -R ~/share
    ```

### O arquivo `nginx.conf`

```xml
Include /etc/proftpd/modules.conf


UseIPv6 off

<IfModule mod_ident.c>
  IdentLookups off
</IfModule>

ServerName "FTP Server"
ServerType standalone
DeferWelcome off

DefaultServer on
ShowSymlinks on

TimeoutNoTransfer 600
TimeoutStalled 600
TimeoutIdle 1200

DisplayLogin welcome.msg
DisplayChdir .message true
ListOptions "-l"

DenyFilter \*.*/

DefaultRoot ~


RequireValidShell off

Port 21


<IfModule mod_dynmasq.c>
</IfModule>

MaxInstances 30

User proftpd
Group nogroup

Umask 022 022

AllowOverwrite on

TransferLog /var/log/proftpd/xferlog
SystemLog /var/log/proftpd/proftpd.log

<IfModule mod_quotatab.c>
QuotaEngine off
</IfModule>

<IfModule mod_ratio.c>
Ratios off
</IfModule>

<IfModule mod_delay.c>
DelayEngine on
</IfModule>

<IfModule mod_ctrls.c>
ControlsEngine off
ControlsMaxClients 2
ControlsLog /var/log/proftpd/controls.log
ControlsInterval 5
ControlsSocket /var/run/proftpd/proftpd.sock
</IfModule>

<IfModule mod_ctrls_admin.c>
AdminControlsEngine off
</IfModule>

 <Anonymous ~ftp>
   User ftp
   Group nogroup

   UserAlias anonymous ftp

   RequireValidShell off

   MaxClients 10

   DisplayLogin welcome.msg
   DisplayChdir .message
   <Directory ~/share>
     <Limit READ WRITE>
       AllowAll
     </Limit>
   </Directory>
 </Anonymous>

Include /etc/proftpd/conf.d/
```
