----------------

```bash
                                              
                                         ▄▄▄▄                        ▄▄                 
                                       ▄█▀▀▀▀█                       ██                 
                                       ██▄        ▄█████▄  ████▄██▄  ██▄███▄    ▄█████▄ 
                                        ▀████▄    ▀ ▄▄▄██  ██ ██ ██  ██▀  ▀██   ▀ ▄▄▄██ 
                                            ▀██  ▄██▀▀▀██  ██ ██ ██  ██    ██  ▄██▀▀▀██ 
                                       █▄▄▄▄▄█▀  ██▄▄▄███  ██ ██ ██  ███▄▄██▀  ██▄▄▄███ 
                                        ▀▀▀▀▀     ▀▀▀▀ ▀▀  ▀▀ ▀▀ ▀▀  ▀▀ ▀▀▀     ▀▀▀▀ ▀▀ 

```
--------------

# Configuração

 1. Para configurar esse serviço primeiro é preciso instalar os pacotes `libcups2, samba-common cups samba` com o seguinte comando:
    
    ```bash
      apt-get install -y libcups2 samba-common cups samba
    ```

2. Agora é necessário fazer o o backup e mover o arquivo `/config/SAMBA/smb.conf` para o diretório `/etc/samba/smb.conf` com os comandos:
    
    ```bash
      mv /etc/samba/smb.conf /etc/samba/smb.conf.bkp
      cp /vagrant_config/SAMBA/smb.conf /etc/samba/smb.conf
    ```

3. Agora é necessário criar um grupo de usuários `users` com o seguinte comando:
   
    ```bash
      groupadd users
    ```
5. O próximo passo é criar os diretórios compartilhados do samba e definir as permissões em cada um deles:

    ```bash
      mkdir -p /home/shares/allusers
      mkdir -p /home/shares/anonymous

      chown -R root:users /home/shares/allusers/
      chmod -R 0771 /home/shares/allusers/
      
      chown -R root:users /home/shares/anonymous/
      chmod -R 0771 /home/shares/anonymous/
    ```
6. Por fim, é preciso criar o usuário para o samba e configurar a senha:

    ```bash
      useradd -m -G users client
      #Definir a senha assim que for requisitado
    ```
7. Agora é só reiniciar o serviço:
   ```bash
     systemctl restart smbd.service
   ```

### O arquivo `smb.conf`

```shell
[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = debian
security = user
map to guest = bad user
dns proxy = no

[allusers]
comment = All Users
path = /home/shares/allusers
valid users = @users
force group = users
create mask = 0660
directory mask = 0771
writable = yes

[homes]
comment = Home Directories
browseable = no
valid users = %S
writable = yes
create mask = 0700
directory mask = 0700

[anonymous]
path = /home/shares/anonymous
force group = users
create mask = 0660
directory mask = 0771
browsable = yes
writable = yes
guest ok = yes
```

# Explicando algumas diretivas

## [global]
- **`workgroup`**: Define o nome do grupo de trabalho. Exemplo: `WORKGROUP`.
- **`server string`**: Descrição do servidor Samba. Exemplo: `Samba Server %v`.
- **`netbios name`**: Nome do servidor na rede. Exemplo: `debian`.
- **`security`**: Método de autenticação. `user` exige autenticação por nome de usuário e senha.
- **`map to guest`**: Mapeia usuários falhos para "guest" (usuário anônimo). Exemplo: `bad user`.
- **`dns proxy`**: Define se o Samba deve usar o proxy DNS. Exemplo: `no`.

## [allusers]
- **`path`**: Caminho do diretório compartilhado. Exemplo: `/home/shares/allusers`.
- **`valid users`**: Usuários ou grupos que têm permissão para acessar o compartilhamento. Exemplo: `@users`.
- **`create mask`**: Permissões para arquivos criados. Exemplo: `0660`.
- **`directory mask`**: Permissões para diretórios criados. Exemplo: `0771`.
- **`writable`**: Permite a gravação. Exemplo: `yes`.

## [homes]
- **`valid users`**: Usuários que podem acessar seus próprios diretórios. Exemplo: `%S` (usuário que está autenticado).
- **`browseable`**: Define se o compartilhamento é visível. Exemplo: `no`.
- **`writable`**: Permite a gravação. Exemplo: `yes`.

## [anonymous]
- **`path`**: Caminho do diretório público. Exemplo: `/home/shares/anonymous`.
- **`guest ok`**: Permite acesso sem autenticação. Exemplo: `yes`.
- **`browseable`**: Define se o compartilhamento é visível. Exemplo: `yes`.
- **`writable`**: Permite a gravação. Exemplo: `yes`.
- **`force group`**: Define o grupo para arquivos criados. Exemplo: `users`.
