# adm-redes
Neste repositório estão os arquivos e scripts de configuração dos serviços de rede do trabalho final da disciplina `Administração de Redes de Computadores - 2024`

## **Alunos**: 
 - Alexandre Neves de Freitas
 - Felipe Fidelis de Almeida Rodrigues


## 🚀 Primeiro passos:

1. **Instalação do Vagrant e VirtualBox**:

   Certifique-se de ter o Vagrant e o VirtualBox instalados na sua máquina.

   - [Instalação do Vagrant](https://www.vagrantup.com/docs/installation)
   - [Instalação do VirtualBox](https://www.virtualbox.org/wiki/Downloads)

3. **Clonando o Repositório**:

   Se ainda não fez o clone do repositório, use o comando abaixo para clonar:
   ```bash
   git clone https://github.com/alexandrendev/adm-redes.git
   ```

4. **Subindo os serviços:**

   Certifique-se de estar na raiz do repositório onde contém o arquivo `Vagrantfile` e use o seguinte comando:
    ```bash
    vagrant up
    ```
5. Após isso executar o `vagrant up`, o vagrant executará o [arquivo de provisão](./provision.sh) que contém os scripts de configuração de cada serviço. 
Ao finalizar as configurações você poderá acessar a máquina virtual pelo terminal utilizando o comando:
   ```bash
   vagrant ssh
   ```
--------
## 🛠️ Serviços Configurados

Cada serviço possui sua própria configuração e documentação detalhada, explicando como ele funciona, como configurá-lo e como utilizá-lo. Abaixo você encontra os links para acessar a documentação de cada serviço.

---

### 🌐 **DHCP** (Dynamic Host Configuration Protocol)
O **DHCP** é responsável pela distribuição dinâmica de endereços IP dentro de uma rede local, facilitando a configuração de dispositivos sem a necessidade de atribuir manualmente um IP para cada um.
- [**Documentação Completa**](./config/DHCP/README.md)

---

### 🌍 **DNS** (Domain Name System)
O **DNS** permite a resolução de nomes de domínio, traduzindo endereços amigáveis como `www.example.com` para endereços IP, permitindo que os usuários acessem websites de forma intuitiva.
- [**Documentação Completa**](./config/DNS/README.md)

---

### 📁 **FTP** (File Transfer Protocol)
O **FTP** é um protocolo utilizado para transferência de arquivos entre sistemas, ideal para fazer upload ou download de arquivos em servidores remotos.
- [**Documentação Completa**](./config/FTP/README.md)

---

### 🌐 **NginX** (Servidor Web)
O **NginX** é um servidor web de alto desempenho que pode ser usado para hospedar sites, aplicações web e também como proxy reverso. Ele é altamente escalável e utilizado em produção por empresas de grande porte.
- [**Documentação Completa**](./config/NginX/README.md)

---

### 🖥️ **SAMBA** (Compartilhamento de Recursos)
O **SAMBA** permite o compartilhamento de arquivos e diretórios entre sistemas Linux e Windows, garantindo que ambos os sistemas possam acessar e modificar arquivos na mesma rede local.
- [**Documentação Completa**](./config/SAMBA/README.md)

---

### 💻 **NFS** (Compartilhamento de Remoto)
O **Network File System (NFS)** é um protocolo que permite o compartilhamento remoto de sistemas de arquivos em uma rede, possibilitando que máquinas cliente acessem arquivos armazenados em um servidor como se fossem locais.
- [**Documentação Completa**](./config/NFS/README.md)

---

## 🔗 Links Úteis

- [Vagrant: Documentação Oficial](https://www.vagrantup.com/docs)
- [NginX: Documentação Oficial](https://nginx.org/en/docs/)
- [Samba: Documentação Oficial](https://www.samba.org/samba/docs/)
