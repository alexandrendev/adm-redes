----------------

```bash
                                       
                                             ▄▄▄▄▄     ▄▄▄   ▄▄    ▄▄▄▄   
                                             ██▀▀▀██   ███   ██  ▄█▀▀▀▀█  
                                             ██    ██  ██▀█  ██  ██▄      
                                             ██    ██  ██ ██ ██   ▀████▄  
                                             ██    ██  ██  █▄██       ▀██ 
                                             ██▄▄▄██   ██   ███  █▄▄▄▄▄█▀ 
                                             ▀▀▀▀▀     ▀▀   ▀▀▀   ▀▀▀▀▀   

```

--------------

# Configuração

1. Para configurar o servidor DNS, primeiro é preciso instalar o serviço `bind9` com o seguinte comando:

    ```bash
    sudo apt install -y bind9 bind9-doc bind9utils dnsutils
    ```

2. Agora é necessário configurar as zonas do domínio no arquivo `/etc/bind/named.conf.local` com o comando:

    ```bash
    sudo nano /etc/bind/named.conf.local
    ```

    Adicione o seguinte conteúdo:

    ```bash
    zone "exemplo.com" {
        type master;
        file "/etc/bind/db.exemplo.com";
    };

    zone "1.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/db.192.168.1";
    };
    ```

3. Crie o arquivo de zona direta `/etc/bind/db.exemplo.com` com o comando:

    ```bash
    sudo nano /etc/bind/db.exemplo.com
    ```

    Adicione o seguinte conteúdo:

    ```bash
    $TTL    604800
    @       IN      SOA     ns.exemplo.com. root.exemplo.com. (
                            2         ; Serial
                            604800    ; Refresh
                            86400     ; Retry
                            2419200   ; Expire
                            604800 )  ; Negative Cache TTL
    ;
    @       IN      NS      ns.exemplo.com.
    @       IN      A       192.168.1.100
    ns      IN      A       192.168.1.100
    www     IN      A       192.168.1.101
    ftp     IN      A       192.168.1.102
    ```

4. Crie o arquivo de zona reversa `/etc/bind/db.192.168.1` com o comando:

    ```bash
    sudo nano /etc/bind/db.192.168.1
    ```

    Adicione o seguinte conteúdo:

    ```bash
    $TTL    604800
    @       IN      SOA     ns.exemplo.com. root.exemplo.com. (
                            1         ; Serial
                            604800    ; Refresh
                            86400     ; Retry
                            2419200   ; Expire
                            604800 )  ; Negative Cache TTL
    ;
    @       IN      NS      ns.exemplo.com.
    100     IN      PTR     ns.exemplo.com.
    101     IN      PTR     www.exemplo.com.
    102     IN      PTR     ftp.exemplo.com.
    ```

5. Por fim, reinicie o serviço e teste o funcionamento com os comandos:

    ```bash
    sudo systemctl restart bind9
    nslookup www.exemplo.com
    ping www.exemplo.com
    ```

-----------
# Explicando os Arquivos de Configuração

### O arquivo named.conf.local

O arquivo `named.conf.local` é utilizado para definir as zonas do servidor DNS. Cada zona representa um domínio e deve apontar para um arquivo de configuração específico. 

Exemplo de configuração:

```bash
zone "exemplo.com" {
    type master;
    file "/etc/bind/db.exemplo.com";
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.1";
};
```

### O arquivo db.exemplo.com

Este é o arquivo que define o mapeamento de nomes para IPs. Ele contém informações como o servidor autoritativo (SOA), os registros de nomes (A) e os servidores de nomes (NS).

Exemplo:

```bash
$TTL    604800
@       IN      SOA     ns.exemplo.com. root.exemplo.com. (
                        2         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;
@       IN      NS      ns.exemplo.com.
@       IN      A       192.168.1.100
ns      IN      A       192.168.1.100
www     IN      A       192.168.1.101
ftp     IN      A       192.168.1.102
```

### O arquivo db.192.168.1

Este é o arquivo que define o mapeamento de IPs para nomes (resolução reversa). 

Exemplo:

```bash
$TTL    604800
@       IN      SOA     ns.exemplo.com. root.exemplo.com. (
                        1         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;
@       IN      NS      ns.exemplo.com.
100     IN      PTR     ns.exemplo.com.
101     IN      PTR     www.exemplo.com.
102     IN      PTR     ftp.exemplo.com.
```

### Testando o Servidor

Use os seguintes comandos para testar:

```bash
nslookup www.exemplo.com
ping www.exemplo.com
```
