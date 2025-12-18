####### BSCAN

# Brazilian
# Processo de restauração de volumes mesmo que não possua os registros em banco de dados.
# Em caso de você possuir o volume backupeado, mas os dados não estarem mais disponíveis no banco de dados por qualquer motivo que seja, como perca do banco, política de retenção já fez expurgo ou falha de configuração.
# O processo de BSCAN NÃO depende do bacula estar configurado, apenas instalado e com o banco de dados ativo, já com as tabelas configuradas (mesmo que zeradas), por se tratar de uma funcionalidade direta do "bconsole".
# É necessário que os acessos ao banco de dados estejam configurados.

# English
# Process for restoring volumes even when database records are not available.
# If you have the backup volume but the data is no longer available in the database for any reason—such as database loss, retention policies having already purged the records, or configuration failure.
# The BSCAN process does not depend on Bacula being configured; it only requires Bacula to be installed and the database to be active, with the tables already created (even if empty), since it is a functionality executed directly through `bconsole`.

# Bscan padrão caso seu banco de dados não possua senha.
# Standard Bscan if your database does not have a password.
bscan -s -m -c /etc/bacula/bacula-sd.conf -v -V "volumeName-0|volumeName-1" /backup

# Caso seu banco de dados seja protegido por senha.
# If your database is password protected.
bscan -s -m -v -c /opt/bacula/etc/bacula-sd.conf -n bacula -u bacula -P senhadobanco -V "volumeName-0|volumeName-1" /backup

# Se tudo ocorrer bem, você receberá essa saída, ela será mais longa, irei apenas cortar uma parte.
# If everything goes well, you will receive this output, which will be longer, but I will just cut out a part of it.

bscan: butil.c:299-0 Using device: "/mnt/storagedata1" for reading.
18-dez 06:33 bscan JobId 0: Ready to read from volume "DB-SRVBACULA-1-11-11-2025-4-43-Full" on File device "storagedata1" (/mnt/storagedata1).
bscan: bscan.c:330-0 Using Database: bacula, User: bacula

Volume Label:
Adata             : 0
Id                : Bacula 1.0 immortal
VerNo             : 11
VolName           : DB-SRVBACULA-1-11-11-2025-4-43-Full
PrevVolName       : 
VolFile           : 0
LabelType         : VOL_LABEL
LabelSize         : 237
PoolName          : DB-SRVBACULA
MediaType         : File1
PoolType          : Backup
HostName          : localhost.localdomain
BlockVer          : BB02
EncCypherKeySize  : 0
MasterKeyIdSize   : 0
Date label written: 11-nov-2025 04:43
bscan: bscan.c:487-0 Pool record for DB-SRVBACULA found in DB.
bscan: bscan.c:501-0 Pool type "Backup" is OK.
bscan: bscan.c:513-0 Media record for DB-SRVBACULA-1-11-11-2025-4-43-Full found in DB.
bscan: bscan.c:543-0 Media type "File1" is OK.
bscan: bscan.c:552-0 VOL_LABEL: OK for Volume: DB-SRVBACULA-1-11-11-2025-4-43-Full

# Para mais ajuda, use:
# For more help, use:

bscan --help

####### BEXTRACT

