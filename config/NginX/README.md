----------------

```bash
                          
                                                                ██                        
                                                                ▀▀                        
                                         ██▄████▄   ▄███▄██   ████     ██▄████▄  ▀██  ██▀ 
                                         ██▀   ██  ██▀  ▀██     ██     ██▀   ██    ████   
                                         ██    ██  ██    ██     ██     ██    ██    ▄██▄   
                                         ██    ██  ▀██▄▄███  ▄▄▄██▄▄▄  ██    ██   ▄█▀▀█▄  
                                         ▀▀    ▀▀   ▄▀▀▀ ██  ▀▀▀▀▀▀▀▀  ▀▀    ▀▀  ▀▀▀  ▀▀▀ 
                                                    ▀████▀▀                               

```
--------------

# Configuração

 1. Para configurar esse serviço primeiro é preciso instalar o `nginx` com o seguinte comando:
    
    ```bash
      apt install -y nginx
    ```

2. Agora é necessário fazer o o backup e mover o arquivo `/config/NginX/nginx.conf` para o diretório `/etc/nginx/nginx.conf` com os comandos:
    
    ```bash
      mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bkp
      cp /vagrant_config/NginX/nginx.conf /etc/nginx/nginx.conf
    ```

3. Agora é só alterar permissões do arquivo de configuração para que o nginx consiga ler e acessar:
    ```bash
      sudo chown root:root /etc/nginx/nginx.conf
      sudo chmod 644 /etc/nginx/nginx.conf
    ```
4. Agora será necessário criar e alterar as permissões para o diretório onde ficará os arquivos HTML a serem servidos pelo NginX. Por padrão ele irá servir o `index.html`, mas você pode criar subdiretórios que serão acessados a partir da página do `index.html`. Para isso é só executar os seguintes comandos: 

    ```bash
      mkdir -p /var/www/example.com/
      sudo chown -R www-data:www-data /var/www/example.com/
      sudo chmod -R 755 /var/www/example.com/
    ```
5. Por fim, é só reiniciar o serviço e testar o funcionamento com os comandos:

    ```bash
       systemctl restart nginx.service
       curl http://<ip_do_servidor>
    ```
