#!/bin/bash

# ==============================
# DZEN2 + Powerline Style
# ==============================

# Fonte nerd font (para setas powerline + ícones)
FONT="-*-Hack Nerd Font-*-*-*-*-12-*-*-*-*-*-*-*"

# Cores
FG="#FFFFFF"
BG="#1D1F21"
C1="#268BD2"
C2="#2AA198"
C3="#859900"
C4="#B58900"
C5="#DC322F"
C6="#6C71C4"

SEP=""

# Interface de rede
IFACE="wlan0"   # troque conforme sua interface

# Funções ======================

cpu() {
    awk -v a="$(grep 'cpu ' /proc/stat)" -v b="$(sleep 1; grep 'cpu ' /proc/stat)" \
    'BEGIN { split(a,ac); split(b,bc);
             user=bc[2]-ac[2]; system=bc[4]-ac[4]; idle=bc[5]-ac[5];
             total=user+system+idle;
             print int((user+system)*100/total)"%"; }'
}

mem() {
    free -m | awk '/Mem/ {print int($3/$2 * 100)"%"}'
}

net() {
    RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
    sleep 1
    RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
    RX_RATE=$(( (RX2 - RX1) / 1024 ))
    TX_RATE=$(( (TX2 - TX1) / 1024 ))
    echo " ${RX_RATE}K  ${TX_RATE}K"
}

temp_cpu() {
    sensors | awk '/Package id 0:/ {print $4}' | sed 's/+//;s/°C//'
}

temp_mobo() {
    sensors | awk '/temp1:/ {print $2}' | sed 's/+//;s/°C//'
}

volume() {
    amixer get Master | awk -F'[][]' 'END{print $2}'
}

clock() {
    date "+%a %d/%m %H:%M"
}

# Workspaces (genérico com ícones)
#  = navegador,  = code,  = terminal,  = música
workspace() {
    echo "      "
}

# ==============================
# Loop da barra
# ==============================

while true; do
    line=""

    # Left side (workspaces)
    line+="^bg($C1)^fg($BG) $(workspace) ^fg($C1)^bg($C2)$SEP"

    # CPU
    line+="^fg($BG)^bg($C2)  $(cpu) ^fg($C2)^bg($C3)$SEP"

    # Mem
    line+="^fg($BG)^bg($C3)  $(mem) ^fg($C3)^bg($C4)$SEP"

    # Net
    line+="^fg($BG)^bg($C4) $(net) ^fg($C4)^bg($C5)$SEP"

    # Temp
    line+="^fg($BG)^bg($C5)  CPU:$(temp_cpu)° MB:$(temp_mobo)° ^fg($C5)^bg($C6)$SEP"

    # Volume
    line+="^fg($BG)^bg($C6)  $(volume) ^fg($C6)^bg($BG)$SEP"

    # Clock
    line+="^fg($BG)^bg($BG) $(clock)"

    echo -e "$line"
done | dzen2 -dock -x "0" -y "0" -h "24" -w "1920" \
    -fn "$FONT" -fg "$FG" -bg "$BG" -ta l
