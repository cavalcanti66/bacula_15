#!/bin/bash

# Backup em tar que separa os arquivos por data, exemplo, tar19112025.tar terá todos os arquivos criados no dia 19.

ORIGEM="/dadosalvo"
DESTINO="/destino"
LISTA_TMP="/mnt/lista_arquivos_$$.txt"

# Cria o destino, se necessário
mkdir -p "$DESTINO"

cd "$ORIGEM" || { echo "Erro: diretório de origem não encontrado."; exit 1; }

# Extrai todas as datas distintas (AAAA-MM-DD) de modificação dos arquivos no diretório de origem
DATAS_ORIGEM=$(find . -type f -printf '%TY-%Tm-%Td\n' | sort -u)

# Extrai as datas já existentes em backups no diretório de destino (com base no nome dos arquivos)
DATAS_BACKUP=$(ls "$DESTINO"/backup_*.tar.gz 2>/dev/null | sed -E 's/.*backup_([0-9]{4}-[0-9]{2}-[0-9]{2})\.tar\.gz/\1/' | sort -u)

# Identifica as datas ausentes
DATAS_FALTANDO=$(comm -23 <(echo "$DATAS_ORIGEM") <(echo "$DATAS_BACKUP"))

# Se não houver datas faltando, encerra
[ -z "$DATAS_FALTANDO" ] && echo "Nenhum backup pendente encontrado." && exit 0

# Loop para processar os dias ausentes
for DATA_ALVO in $DATAS_FALTANDO; do
    ARQUIVO_TAR="backup_${DATA_ALVO}.tar.gz"
    echo "Criando backup para $DATA_ALVO..."

    # Gera lista de arquivos alterados naquele dia
    find . -type f -newermt "$DATA_ALVO" ! -newermt "$DATA_ALVO +1 day" > "$LISTA_TMP"

    if [ -s "$LISTA_TMP" ]; then
        tar -czf "$DESTINO/$ARQUIVO_TAR" -T "$LISTA_TMP"
        echo "Backup criado: $DESTINO/$ARQUIVO_TAR"
    else
        echo "Nenhum arquivo encontrado em $DATA_ALVO. Pulando..."
    fi

    rm -f "$LISTA_TMP"
done

echo "Processo concluído."
