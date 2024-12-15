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

### O arquivo `nginx.conf`

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
}

http {

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	gzip on;


	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;

	server {
    	listen       80 default_server;
    	listen       [::]:80 default_server;
    	server_name  _;
    	root         /usr/share/nginx/html;
	}
	
	server {
		server_name  example.com;
		root         /var/www/example.com/;
		access_log   /var/log/nginx/access.log;
		error_log    /var/log/nginx/error.log;
	}

}

```

# Explicando algumas diretivas

Aqui o bloco onde realizamos as configurações é o bloco `http`, onde colocamos os blocos `server` com as configurações do servidor.

- `listen       80 default_server;`: Define o servidor para escutar na porta 80 (ipv4)
- `listen       [::]:80 default_server;`: Define o servidor para escutar na porta 80 (ipv6)
- `root         /var/www/example.com/;`: Define o diretório raiz onde o servidor irá buscar os arquivos .html
- `access_log && error_log`: Definem os diretórios onde o servidor registrará arquivos de log.
