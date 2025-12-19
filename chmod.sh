#!/bin/bash

# Altera todas as permissões de todos os arquivos de X diretório.

DIRETORIO_ALVO="/dadosalvo"

#(770: Proprietario e Grupo tem leitura/escrita/execução; Outros não tem acesso).

PERMISSAO="770"

echo "Iniciando a alteracao das permissoes para $PERMISSAO no diretorio: $DIRETORIO_ALVO"
echo "Permissoes 770: (rwx para Proprietario e Grupo, --- para Outros)"
echo "------------------------------------------------------------"

# Verifica se o diretorio existe
if [ ! -d "$DIRETORIO_ALVO" ]; then
    echo "ERRO: O diretorio $DIRETORIO_ALVO não foi encontrado."
    exit 1
fi

find "$DIRETORIO_ALVO" -type f -exec chmod "$PERMISSAO" {} +

if [ $? -eq 0 ]; then
    echo "SUCESSO: Todas as permissoes de arquivos em $DIRETORIO_ALVO foram alteradas para $PERMISSAO."
else
    echo "AVISO: Ocorreu um erro durante a execucao do comando find/chmod."
fi

exit 0
