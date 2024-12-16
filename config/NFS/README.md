----------------

```bash\
                                                   ███   ██  ██▀▀▀▀▀▀  ▄█▀▀▀▀█  
                                                   ██▀█  ██  ██        ██▄      
                                                   ██ ██ ██  ███████    ▀████▄  
                                                   ██  █▄██  ██             ▀██ 
                                                   ██   ███  ██        █▄▄▄▄▄█▀ 
                                                   ▀▀   ▀▀▀  ▀▀         ▀▀▀▀▀   
```

--------------

# Configuração do Servidor NFS

Introdução

O **Network File System (NFS)** é um protocolo que permite o compartilhamento remoto de sistemas de arquivos em uma rede, possibilitando que máquinas cliente acessem arquivos armazenados em um servidor como se fossem locais.

Passos de Configuração

1. Instalação dos Pacotes Necessários
Para configurar o NFS, instale os pacotes nfs-common e nfs-kernel-server no servidor:

```bash
sudo apt-get update
sudo apt-get install nfs-common nfs-kernel-server
```
2. Configuração do Diretório Compartilhado
Crie o diretório que será exportado para os clientes:

```bash
sudo mkdir -p /home/storage
```
Defina as permissões adequadas para o diretório:

```bash

sudo chmod 777 /home/storage
```
3. Configuração do Arquivo /etc/exports
Edite o arquivo /etc/exports para especificar as regras de compartilhamento:

```bash

sudo nano /etc/exports
```
Adicione o seguinte conteúdo:

```bash
/home/storage 192.168.0.100(rw,sync,no_root_squash)
```
/home/storage: O diretório a ser compartilhado.
192.168.0.100: IP do cliente autorizado a acessar o compartilhamento.
rw: Permite leitura e escrita.
sync: Garante que as operações sejam sincronizadas.
no_root_squash: Permite que o cliente root mantenha seus privilégios.
Recarregue as configurações do arquivo /etc/exports:

```bash
sudo exportfs -r
```
4. Reinicie os Serviços
Reinicie os serviços para aplicar as configurações:

```bash
sudo systemctl restart nfs-kernel-server
```
Verifique se as portas estão abertas:

```bash
sudo netstat -tuln | grep nfs
```

5. Configuração no Cliente
No cliente, crie um ponto de montagem:

```bash

sudo mkdir -p /mnt/nfs_storage
```
Monte o compartilhamento NFS:

```bash

sudo mount 192.168.0.100:/home/storage /mnt/nfs_storage
```
192.168.0.100: IP do servidor.
/home/storage: Diretório no servidor.
/mnt/nfs_storage: Ponto de montagem no cliente.
Verifique se o compartilhamento foi montado:

6. Testes e Verificação
Teste a conexão ao diretório compartilhado e verifique se a leitura e escrita estão funcionando corretamente:

````bash
cd /mnt/nfs_storage
sudo touch teste.txt
ls -l
````
Solução de Problemas
Verifique os logs do sistema para identificar erros:

```bash
sudo tail -f /var/log/syslog
```

Certifique-se de que o firewall permite conexões nas portas 111, 892 e 2049.

Confirme que o IP do cliente está listado no arquivo /etc/exports do servidor.

Referências
Documentação Oficial do Debian sobre NFS
Artigo sobre FSTAB
Agora seu servidor NFS está configurado e pronto para uso!
