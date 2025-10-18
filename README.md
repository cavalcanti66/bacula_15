# Sobre o Bacula Community

Bacula Community é a edição open source do sistema Bacula, uma plataforma de backup, recuperação e verificação de dados voltada para ambientes corporativos e servidores, com código-fonte público e suporte da comunidade.

# Características principais:
– Arquitetura modular, composta por cinco componentes principais:

• Director (DIR): coordena os jobs de backup, restore e verificação.

• Storage Daemon (SD): gerencia os dispositivos de armazenamento, como discos, fitas ou bibliotecas virtuais.

• File Daemon (FD): cliente instalado nas máquinas a serem protegidas; envia e recebe dados.

• Catalog: banco de dados (PostgreSQL, MySQL/MariaDB, SQLite) que armazena metadados dos backups.

• Console: interface de administração via CLI (bconsole) ou web (Baculum).

– Suporte a múltiplos tipos de mídia (disco, fita, nuvem, volumes criptografados).

– Controle granular de políticas de retenção, agendamento e rotação de volumes.

– Criptografia, compressão e deduplicação integráveis.

– Capacidade de restaurar arquivos individuais ou sistemas completos.

– Escalabilidade adequada para ambientes com dezenas a milhares de clientes.

– Integração com scripts externos, hooks e automação via API do Baculum.

# Documentação de instalação e configurações Bacula 15

Processo de instalação e configuração do Bacula 15.0.3 e Bacularis (interface gráfica baseada em baculum).

Nesse repositório guardei informações sobre o processo em Ubuntu 24.02 e Oracle Linux 9 U6, adapte a sua realidade e necessidade.

Também existem projetos e imagens em docker e coisas do genero, mas tudo feito pela comunidade.
https://hub.docker.com/search?q=bacula&type=image

# Cadastro para receber um repositório do Bacula via e-mail
https://www.bacula.org/bacula-binary-package-download/

# Documentações oficiais do Bacula Community
https://www.bacula.org/documentation/documentation/

# Site oficial do Bacularis e sua documentação
Diferente do Bacula Community que é mantido pela bacula.org, o Bacularis é um projeto feito pela comunidade, evolução do Baculum.
https://bacularis.app/

# Recomendação pessoal de conteúdo BR sobre o Bacula Community
https://www.youtube.com/@podheitor

Mais informações em breve.
