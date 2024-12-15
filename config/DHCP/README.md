----------------

```bash
                                            ▄▄▄▄▄     ▄▄    ▄▄     ▄▄▄▄   ▄▄▄▄▄▄   
                                            ██▀▀▀██   ██    ██   ██▀▀▀▀█  ██▀▀▀▀█▄ 
                                            ██    ██  ██    ██  ██▀       ██    ██ 
                                            ██    ██  ████████  ██        ██████▀  
                                            ██    ██  ██    ██  ██▄       ██       
                                            ██▄▄▄██   ██    ██   ██▄▄▄▄█  ██       
                                            ▀▀▀▀▀     ▀▀    ▀▀     ▀▀▀▀   ▀▀ 

```
--------------

# Configuração

 1. Para configurar esse serviço primeiro é preciso instalar o serviço `isc-dhcp-server` com o seguinte comando:
    
    ```bash
      apt install -y isc-dhcp-server
    ```

2. Agora é necessário fazer o o backup e mover o arquivo `/config/DHCP/dhcpd.conf` para o diretório `/etc/dhcp/dhcpd.conf` com os comandos:
    
    ```bash
      mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bkp
      cp /vagrant_config/DHCP/dhcpd.conf /etc/dhcp/dhcpd.conf
    ```

3. Por fim, é só reiniciar o serviço e testar o funcionamento com os comandos:

    ```bash
       systemctl restart isc-dhcp-server // No servidor
       sudo dhclient -r <interface> // Na máquina do cliente
       sudo dhclient <interface> // Na máquina do cliente
    ```
-----------
# O arquivo dhcpd.conf

A estrutura básica do arquivo `dhcpd.conf` para o funcionamento do serviço é a seguinte:

```conf
  # dhcpd.conf
  #
  # Sample configuration file for ISC dhcpd
  #
  # Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as
  # configuration file instead of this file.
  #
  
  # option definitions common to all supported networks...
  option domain-name "example.org";
  option domain-name-servers ns1.example.org, ns2.example.org;
  
  default-lease-time 600;
  max-lease-time 7200;
  
  ddns-update-style none;
  
  subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.99 192.168.1.200;
  option subnet-mask 255.255.255.0;
  option domain-name "iftm.edu.br";
  option domain-name-servers 8.8.8.8, 8.8.4.4;
  option routers 192.168.1.1;
  default-lease-time 600;
  max-lease-time 7200;
  }
```

### Explicando algumas diretivas

- `subnet 192.168.1.0 netmask 255.255.255.0`:  Inicia o bloco de configurações para a subrede 192.168.1.0/24
- `range 192.168.1.99 192.168.1.200;`: Define a faixa de IPs a serem servidos pelo servidor
- `option domain-name-servers 8.8.8.8, 8.8.4.4;`: Define o servidor DNS a ser utilizado pelos clientes (Google DNS)
- `option routers 192.168.1.1;`: Define o gateway padrão que os clientes utilizarão
- `default-lease-time 600; && max-lease-time 7200;`: Define o tempo padrão e o tempo máximo de concessão/aluguel de endereços
