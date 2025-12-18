# Brazilian
# Processo de restauração de volumes mesmo que não possua os registros em banco de dados.
# Em caso de você possuir o volume backupeado, mas os dados não estarem mais disponíveis no banco de dados por qualquer motivo que seja, como perca do banco, política de retenção já fez expurgo ou falha de configuração.
# O processo de BSCAN NÃO depende do bacula estar configurado, apenas instalado e com o banco de dados ativo, já com as tabelas configuradas (mesmo que zeradas), por se tratar de uma funcionalidade direta do "bconsole".
# É necessário que os acessos ao banco de dados estejam configurados.

# English
# Process for restoring volumes even when database records are not available.
# If you have the backup volume but the data is no longer available in the database for any reason—such as database loss, retention policies having already purged the records, or configuration failure.
# The BSCAN process does not depend on Bacula being configured; it only requires Bacula to be installed and the database to be active, with the tables already created (even if empty), since it is a functionality executed directly through `bconsole`.

bscan -s -m -c /etc/bacula/bacula-sd.conf -v -V "volumeName-0|volumeName-1" /backup

# Parametros
# -s — Sincroniza os registros encontrados com o banco de dados.
# -m — Atualiza as informações de mídia/volume no catálogo.
# -c — Define o caminho do arquivo de configuração do Storage Daemon.
# /etc/bacula/bacula-sd.conf — Arquivo de configuração do Storage Daemon utilizado no processo.
# -v — Ativa modo verbose para detalhamento da execução.
# -V — Especifica o nome do volume ou lista de volumes (regex ou separação por |).
# /backup — Diretório onde os volumes de backup estão armazenados.

# Parameters
# -s — Synchronizes discovered records with the database.
# -m — Updates media/volume information in the catalog.
# -c — Specifies the Storage Daemon configuration file path.
# /etc/bacula/bacula-sd.conf — Storage Daemon configuration file used during execution.
# -v — Enables verbose output.
# -V — Defines the volume name or list of volumes (regex or | separated).
# /backup — Directory where the backup volumes are currently stored.
