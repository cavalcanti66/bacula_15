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
