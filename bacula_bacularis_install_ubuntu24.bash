# Bacula Community 15.0.3 - Ubuntu Server 24.02

# Instalar dependencias

sudo apt-get update
sudo apt-get install apt-transport-https

# Adicione a chave ASC e remova em seguida

cd /tmp

sudo wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc

sudo apt-key add Bacula-4096-Distribution-Verification-key.asc

sudo rm Bacula-4096-Distribution-Verification-key.asc

# Crie o repositorio no linux

sudo vi /etc/apt/sources.list.d/Bacula-Community.list

# Adicione isso ao arquivo (adapte a sua necessidade, se cadastre no site oficial da bacula systems para obter um repositorio)

#Bacula Community
deb [arch=amd64] https://www.bacula.org/packages/abc123defxxxyyy/debs/13.0.1 xenial main

# Atualize os repositorios novamente

sudo apt-get update

# Instale o banco de dados

sudo apt-get install postgresql postgresql-client

# Instale o software

sudo apt-get install bacula-postgresql

# O APT vai perguntar se voce quer configurar o banco, confirme que sim e crie uma senha.

# Inicie o servico do banco

sudo systemctl start postgresql.service

# Acesse o banco como root

sudo su - postgres

# Execute os seguintes scripts para criacao de tabelas e permissoes necessarias

/opt/bacula/scripts/create_postgresql_database
/opt/bacula/scripts/make_postgresql_tables
/opt/bacula/scripts/grant_postgresql_privileges

# Saia do banco

exit

# Inicie os servicos do bacula

sudo systemctl start bacula-fd.service
sudo systemctl start bacula-sd.service
sudo systemctl start bacula-dir.service

# Agora teste a estrutura, rode o bconsole

sudo -u bacula /opt/bacula/bin/bconsole

# Rode um backup, use o comando help para obter ajuda ou consulte as documentacoes.

run job=BackupCatalog
messages
status dir
quit

# Status que deve ser exibido

bacula15-dir Version: 15.0.3 (25 March 2025) x86_64-pc-linux-gnu-bacula ubuntu 24.04
Daemon started 25-Sep-25 07:22, conf reloaded 25-Sep-2025 07:22:49
 Jobs: run=1, running=0 max=20 mode=0,0
 Crypto: fips=N/A crypto=OpenSSL 3.0.13 30 Jan 2024
 Heap: heap=540,672 smbytes=428,739 max_bytes=472,015 bufs=472 max_bufs=519
 Res: njobs=3 nclients=1 nstores=2 npools=3 ncats=1 nfsets=2 nscheds=2

Scheduled Jobs (2/50):
Level          Type     Pri  Scheduled          Job Name           Volume
===================================================================================
Incremental    Backup    10  25-Sep-25 23:05    BackupClient1      Vol-0001
Full           Backup    11  25-Sep-25 23:10    BackupCatalog      Vol-0001
====

Running Jobs:
Console connected using TLS at 25-Sep-25 07:28
No Jobs running.
====

Terminated Jobs:
 JobId  Level     Files      Bytes   Status   Finished        Name 
====================================================================
     1  Full           1    64.05 K  OK       25-Sep-25 07:28 BackupCatalog

# A partir disso, basta seguir com as demais configs, como pontos de montagem NFS, ISCSI ou Daemons de armazenamento.
# Definir ou migrar de outro servidor como clientes, configuracoes de jobs, etc.

# Instalação manual do Bacularis, tambem tem como instalar via Docker, Composer ou por pacotes.

# Você pode baixar todos eles para o mesmo diretório da seguinte maneira (exemplo para a versão 4.7.1):

BACULARIS_VER=4.7.1
mkdir -p /var/www/bacularis
cd /var/www/bacularis
wget -O bacularis-api-$BACULARIS_VER.tar.gz https://github.com/bacularis/bacularis-api/archive/refs/tags/$BACULARIS_VER.tar.gz
wget -O bacularis-common-$BACULARIS_VER.tar.gz https://github.com/bacularis/bacularis-common/archive/refs/tags/$BACULARIS_VER.tar.gz
wget -O bacularis-web-$BACULARIS_VER.tar.gz https://github.com/bacularis/bacularis-web/archive/refs/tags/$BACULARIS_VER.tar.gz
wget -O bacularis-app-$BACULARIS_VER.tar.gz https://github.com/bacularis/bacularis-app/archive/refs/tags/$BACULARIS_VER.tar.gz
wget https://bacularis.app/downloads/bacularis-external-$BACULARIS_VER.tar.gz

# Depois que os arquivos de origem forem baixados, você poderá extraí-los e preparar os arquivos Bacularis conforme descrito abaixo:

tar --strip-components 1 -zxvf bacularis-app-$BACULARIS_VER.tar.gz
tar --strip-components 1 -C protected -zxvf bacularis-external-$BACULARIS_VER.tar.gz
mkdir -p protected/vendor/bacularis/bacularis-common
mkdir -p protected/vendor/bacularis/bacularis-api
mkdir -p protected/vendor/bacularis/bacularis-web
tar --strip-components 1 -C protected/vendor/bacularis/bacularis-common -zxvf bacularis-common-$BACULARIS_VER.tar.gz
tar --strip-components 1 -C protected/vendor/bacularis/bacularis-api -zxvf bacularis-api-$BACULARIS_VER.tar.gz
tar --strip-components 1 -C protected/vendor/bacularis/bacularis-web -zxvf bacularis-web-$BACULARIS_VER.tar.gz

# NOTA: esta barra invertida em cp é intencional

\cp -rf protected/vendor/bacularis/bacularis-common/project/* ./
cp protected/vendor/bacularis/bacularis-common/project/protected/samples/webserver/bacularis.users.sample protected/vendor/bacularis/bacularis-api/API/Config/bacularis.users
cp protected/vendor/bacularis/bacularis-common/project/protected/samples/webserver/bacularis.users.sample protected/vendor/bacularis/bacularis-web/Web/Config/bacularis.users
ln -s vendor/bacularis/bacularis-common/Common protected/Common
ln -s vendor/bacularis/bacularis-api/API protected/API
ln -s vendor/bacularis/bacularis-web/Web protected/Web
cp protected/vendor/npm-asset/fortawesome--fontawesome-free/css/all.min.css htdocs/themes/Baculum-v2/fonts/css/fontawesome-all.min.css
cp -r protected/vendor/npm-asset/fortawesome--fontawesome-free/webfonts/* htdocs/themes/Baculum-v2/fonts/webfonts/

# Agora, se quiser, pode deletar os arquivos originais

rm -f bacularis-common-$BACULARIS_VER.tar.gz \
     bacularis-api-$BACULARIS_VER.tar.gz \
     bacularis-web-$BACULARIS_VER.tar.gz \
     bacularis-app-$BACULARIS_VER.tar.gz \
     bacularis-external-$BACULARIS_VER.tar.gz

# Agora será feita a instalação do web server, nesse caso, irei usar o nginx, adapte a sua necessidade.

apt install nginx \
              php-fpm \
              php-bcmath \
              php-curl \
              php-xml \
              php-json \
              php-ldap \
              php-mysql \
              php-pdo \
              php-pgsql \
              php-intl \
              expect

# Agora faremos a configuração inicial

protected/tools/install.sh -p /run/php/php-fpm.sock

# Após executar o script install.sh, você deve receber a seguinte saída: 

+===================================================+
|      Welcome in the Bacularis install script      |
+---------------------------------------------------+
|  This script will help you to adjust privileges   |
|  for Bacularis files and it will prepare          |
|  configuration files for popular web servers.     |
+---------------------------------------------------+



What is your web server type?
1 Apache (default)
2 Nginx
3 Lighttpd
4 Other
Please type number between 1-4 [1]: 2

What is your web server user? [www-data]: www-data
[INFO] Web server config file you can find in /var/www/bacularis/bacularis-nginx.conf
[INFO] Please move it to appropriate location.
[INFO] End.

# Agora você precisa fornecer a configuração do servidor web preparada para o diretório de arquivos de configuração do servidor web:

mv /var/www/bacularis/bacularis-nginx.conf /etc/nginx/conf.d/

# Reinicie o Web Server

systemctl restart nginx

# A interface web do Bacularis está disponível em http://localhost:9097 com o usuário padrão admin e a senha admin.
# Durante o wizard de configuração do Bacularis, será necessário atribuir algumas configurações a um arquivo, segue abaixo.

vi /etc/sudoers.d/bacularis-api

# Insira o sequinte conteúdo

Defaults:www-data !requiretty
www-data ALL = (root) NOPASSWD: /usr/bin/bconsole
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bdirjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bsdjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bfdjson
www-data ALL = (root) NOPASSWD: /opt/bacula/bin/bbconsjson

# Salve o arquivo

# Durante o Wizard, também será solicitado algumas coisas, como configuração de banco de dados e caminhos dos arquivos do bacula, adapte a sua necessidade, mas aqui está como ficou no Ubuntu 24.02

# Caminho para o bconsole

/usr/bin/bconsole

#  Caminho do bconsole.conf: 

/opt/bacula/etc/bconsole.conf

#  Diretório de trabalho do Baculum (bacularis foi criado com base no baculum hehe) para a configuração do Bacula: 

/var/www/bacularis/protected/vendor/bacularis/bacularis-api/API/Config

# Director
# Caminho do binário bdirjson:

/opt/bacula/bin/bdirjson

# Caminho da configuração do Director (geralmente bacula-dir.conf): 

/opt/bacula/etc/bacula-dir.conf

# Storage Daemon
# Caminho do binário bsdjson: 

/opt/bacula/bin/bsdjson

# Caminho da configuração do Storage (geralmente bacula-sd.conf):

/opt/bacula/etc/bacula-sd.conf

# File Daemon/Clients
# Caminho do binário bfdjson: 

/opt/bacula/bin/bfdjson

# Caminho da configuração do File Daemon (geralmente bacula-fd.conf):

/opt/bacula/etc/bacula-fd.conf

# Bconsole
# Caminho do binário bbconsjson: 

/opt/bacula/bin/bbconsjson

# Caminho de configuração do Bconsole (geralmente bconsole.conf):

/opt/bacula/etc/bconsole.conf
