bacula_version="15.0.3"

# Digite a chave recebida por email
bacula_key="6367abb52d166"

# Requisitos para instalar o Bacula por pacotes
yum install -y zip wget bzip2


# Download da chaves do repositório
wget -c https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc -O /tmp/Bacula-4096-Distribution-Verification-key.asc

# Gambiarra só para aceitar a chave legado
update-crypto-policies --set DEFAULT:SHA1

# Adicionar chave no repositório local
rpm --import /tmp/Bacula-4096-Distribution-Verification-key.asc


# Criar o repositório do Bacula Community
echo "[Bacula-Community]
name=CentOS - Bacula - Community
baseurl=http://www.bacula.org/packages/6367abb52d166/rpms/15.0.3/el9/x86_64/
enabled=1
protect=0
gpgcheck=0" > /etc/yum.repos.d/bacula-community.repo


###################################################################
# Instalar o Banco de Dados MySQL ou PostgreSQL
# Selecione os comandos de acordo com a opção desejada

# Instalar PostgreSQL
yum install -y postgresql-server
yum install -y bacula-postgresql --exclude=bacula-mysql
postgresql-setup initdb


# Habilitar e iniciar o PostgreSQL durante o boot
systemctl enable postgresql
systemctl start postgresql


# Criar o banco de dados do Bacula com PostgreSQL
su - postgres -c "/opt/bacula/scripts/create_postgresql_database"
su - postgres -c "/opt/bacula/scripts/make_postgresql_tables"
su - postgres -c "/opt/bacula/scripts/grant_postgresql_privileges"
###################################################################

# Desabilita selinux:
setenforce 0
sudo sed -i "s/enforcing/disabled/g" /etc/selinux/config
# Regras de Firewall
firewall-cmd --permanent --zone=public --add-port=9101-9103/tcp
firewall-cmd --reload

# Habilitar o início dos daemons durante o boot
systemctl enable bacula-fd.service
systemctl enable bacula-sd.service
systemctl enable bacula-dir.service


# Iniciar os daemons do Bacula
systemctl start bacula-fd.service
systemctl start bacula-sd.service
systemctl start bacula-dir.service


# Criar atalho em /usr/sbin com os binários do Bacula
# Isso permite rodar os daemons e utilitários
# Sem entrar no diretório /opt/bacula/bin
for i in `ls /opt/bacula/bin`; do
	ln -s /opt/bacula/bin/$i /usr/sbin/$i;
done


# Substituir o endereço do bconsole.conf para localhost por padrão
sed '/[Aa]ddress/s/=\s.*/= localhost/g' -i  /opt/bacula/etc/bconsole.conf

###################################################################
# Exemplo instalação Bacularis

echo "# Bacularis - Oracle Linux 9 package repository
[bacularis-app]
name=Oracle Linux 9 package repository
baseurl=https://packages.bacularis.app/stable/oraclelinux9
gpgcheck=1
gpgkey=https://packages.bacularis.app/bacularis.pub
username=ofSiTCubmzlnLEysNkUK
password=udr5MYDKvAZQH78kWpRqaPlBXS2mytVsFw1b3hCO
enabled=1" > /etc/yum.repos.d/bacularis-app.repo

# Instala o Bacularis
dnf install bacularis bacularis-httpd bacularis-selinux

# Inicia/reinicia o Apache
systemctl restart httpd

# Inicia servico do servidor web no boot 
systemctl enable httpd
systemctl start httpd


# Regras de Firewall
firewall-cmd --permanent --zone=public --add-port=9096-9097/tcp
firewall-cmd --reload

# Mudar autenticação Pgsql para trust
sed -i 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf
service postgresql restart

# Ajusta permissões
chown -R bacula /opt/bacula

echo 'Defaults:apache !requiretty
apache ALL = (root) NOPASSWD: /usr/bin/bconsole
apache ALL = (root) NOPASSWD: /opt/bacula/bin/bdirjson
apache ALL = (root) NOPASSWD: /opt/bacula/bin/bsdjson
apache ALL = (root) NOPASSWD: /opt/bacula/bin/bfdjson
apache ALL = (root) NOPASSWD: /opt/bacula/bin/bbconsjson' > /etc/sudoers.d/bacularis

# The Bacularis web interface is available at http://localhost:9097 with default user admin and password admin.
