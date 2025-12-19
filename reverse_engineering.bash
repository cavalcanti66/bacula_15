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

# Quando o processo terminar, será criado um job com a data de quando o volume foi criado a primeira vez e será readicionado ao banco de dados. Em seguida, faça o processo de restore.
# When the process is complete, a job will be created with the date when the volume was first created and will be added back to the database. Then perform the restore process.

# O processo pode demorar a depender do tamanho do volume, porque ele fará um "novo" backup no banco.
# The process may take some time depending on the size of the volume, because it will perform a “new” backup in the database.

# Para mais ajuda, use:
# For more help, use:

bscan --help

####### BEXTRACT

# Processo de extração de backups diretamente dos volumes, sem passar pelo banco de dados nem pelas ferramentas de restauração. Recomendado apenas em casos extremos.
# This process extracts backups directly from volumes, bypassing the database and standard restoration tools. Recommended only for extreme cases or disaster recovery.

bextract -c /opt/bacula/etc/bacula-sd.conf -v -V volumename /storagevol /caminhorestore

# Sintaxe 
# /opt/bacula/etc/bacula-sd.conf = # Local do arquivo SD Conf
# volumename = Nome do volume
# /storagevol = Local onde está armazenado
# /caminhorestore = Onde será restaurado

# Command Syntax
bextract -c /opt/bacula/etc/bacula-sd.conf -v -V volumename /storagevol /restorepath

# Parameter Breakdown:

# /opt/bacula/etc/bacula-sd.conf: Path to the Storage Daemon configuration file.
# volumename: The specific name of the volume.
# /storagevol: The directory where the volume file is stored.
# /restorepath: The destination directory for the restored files.

# Se tudo ocorrer bem, você receberá a seguinte saída
# Expected Output. If the process runs successfully, you will see an output similar to this:

[root@localhost testebextract]# bextract -c /opt/bacula/etc/bacula-sd.conf -v -V volumename /storagevol /caminhorestore
bextract: butil.c:299-0 Using device: "/storagevol" for reading.
18-dez 23:21 bextract JobId 0: Ready to read from volume "volumename" on File device "volumenameB" (/storagevol).
bextract JobId 0: -rw-------   1 sssd     clevis           3762707822 2025-12-01 13:26:10  /caminhorestore/testebextract/opt/bacula/working/bacula.sql
bextract JobId 0: -rw-------   1 sssd     clevis           3212665014 2025-12-02 02:10:10  /caminhorestore/testebextract/opt/bacula/working/bacula.sql
bextract JobId 0: -rw-------   1 sssd     clevis           3212668936 2025-12-02 02:14:11  /caminhorestore/testebextract/opt/bacula/working/bacula.sql
18-dez 23:26 bextract JobId 0: End of Volume "volumename" at addr=10195598452 on device "storagevol" (/storagevol).
3 files restored.

# Se voce quiser, também pode criar uma lista de arquivos a serem restaurados, mas vai precisar do caminho exato dos arquivos. A lista suporta expressão regular.

bextract -i /tmp/lista -c /opt/bacula/etc/bacula-sd.conf -v -V diaria-0 /backup /tmp

# You can also provide a list of specific files to restore. Note that you must use the exact file paths. This list supports regular expressions (regex).

bextract -i /tmp/filelist -c /opt/bacula/etc/bacula-sd.conf -v -V daily-0 /backup /tmp

# -i /tmp/filelist: Specifies the input file containing the list of files/patterns to be restored.
