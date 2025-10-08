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
