#!/bin/bash
# ~/.config/dzen2/start.sh
# Script para iniciar o dzen2 com a barra powerline

# Matar instâncias antigas
pkill -x dzen2

# Dar um tempo para garantir que fechou
sleep 1

# Caminho do script da barra
PANEL="$HOME/.config/dzen2/panel.sh"

# Verifica se o script existe
if [ ! -f "$PANEL" ]; then
    echo "Erro: $PANEL não encontrado!"
    exit 1
fi

# Executa em background
$PANEL &
