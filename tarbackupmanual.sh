#!/bin/sh

ORIGEM="/mnt/dados"
DESTINO="/mnt/backup"
LISTA_TMP="/tmp/lista_arquivos_$$.txt"

# Lista de datas manual (exemplo)
DATAS="2025-12-01"

# Cria destino, se necessário
mkdir -p "$DESTINO"

# Loop pelas datas
for DATA_ALVO in $DATAS; do
    ARQUIVO_TAR="backup_${DATA_ALVO}.tar.gz"

    echo "Processando arquivos de $DATA_ALVO..."

    cd "$ORIGEM" || { echo "Erro: diretório de origem não encontrado."; exit 1; }

    # Cria lista de arquivos modificados exatamente no dia
    find . -type f -newermt "$DATA_ALVO" ! -newermt "$DATA_ALVO +1 day" > "$LISTA_TMP"

    if [ -s "$LISTA_TMP" ]; then
        tar -czvf "$DESTINO/$ARQUIVO_TAR" -T "$LISTA_TMP"
        echo "Backup criado: $DESTINO/$ARQUIVO_TAR"
    else
        echo "Nenhum arquivo encontrado em $DATA_ALVO. Pulando..."
    fi

    rm -f "$LISTA_TMP"
done



