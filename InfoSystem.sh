#!/bin/bash

#--------------------------------#
# Script Infos R36S - ArkOS AeUX #
#--------------------------------#

if [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$0" "$@"
fi

CURR_TTY="/dev/tty1"
APP_NAME="R36S System Info by Jason"

printf "\033c" > "$CURR_TTY"
printf "\e[?25l" > "$CURR_TTY" # Hide cursor
dialog --clear
export TERM=linux
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    setfont /usr/share/consolefonts/Lat7-TerminusBold20x10.psf.gz
else
    setfont /usr/share/consolefonts/Lat7-Terminus20x10.psf.gz
fi

pkill -9 -f gptokeyb || true
pkill -9 -f osk.py || true

printf "\033c" > "$CURR_TTY"
printf "Starting Info System\nPlease wait..." > "$CURR_TTY"
sleep 1

ExitMenu() {
    printf "\033c" > "$CURR_TTY"
    printf "\e[?25h" > "$CURR_TTY" # Show cursor
    pkill -f "gptokeyb -1 InfoSystem.sh" || true
    if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
        setfont /usr/share/consolefonts/Lat7-Terminus20x10.psf.gz # Restore a common font
    fi
    exit 0
}


# --- Détection du panel ---
DetectPanel() {
     # Vérification si un paramètre panel= existe
    local PANEL_PARAM
    PANEL_PARAM=$(sed -n 's/.*panel=\([^ ]*\).*/\1/p' /proc/cmdline 2>/dev/null)
    if [ -n "$PANEL_PARAM" ]; then
        [[ "$PANEL_PARAM" = "unset" ]] && echo "Panel 4" && return
        echo "Panel $PANEL_PARAM"
        return
    fi
    
    DTB_FILES=$(ls /boot/*.dtb 2>/dev/null)

    # Base de données MD5
    declare -A dtb_md5=(
      ["bfc6068ef7d80575bef04b36ef881619"]="Panel 0"
    ["d41d8cd98f00b204e9800998ecf8427e"]="Panel 0"
      ["a3d55922b4ccce3e2b23c57cefdd9ba7"]="Panel 1"
    ["28792e1126f543279237ec45de5c03e5"]="Panel 1"
    ["3869152c5fb8e5c0e923f7f00e42231e"]="Panel 1"
    ["098f6bcd4621d373cade4e832627b4f6"]="Panel 1"
      ["a5d6f30491abac29423d0c1334ad88d3"]="Panel 2"
    ["2d82650c523ac734a16bddf600286d6d"]="Panel 2"
    ["daf777a6b5ed355c3aaf546da4e42da9"]="Panel 2"
    ["e99a18c428cb38d5f260853678922e03"]="Panel 2"
      ["b3bf18765a4453b8eaeaf60362b79b3d"]="Panel 3 (v3)"
    ["f6984db1b07f03a90c182c59dd51ccf0"]="Panel 3 (v3)"
    ["aab3238922bcc25a6f607c66ea7d5baf"]="Panel 3"
      
["543038f0cc9b515401186ebbde232cfa"]="Panel 3 (v4)"
    ["9f41df45acac67bff88ec52306efc225"]="Panel 3 (v4)"
    ["72856dd54e77a0fd61d9c2a59b08b685"]="Panel 3 (v4)"
    ["040b5bfff8c1969aaeedcfbe8a33ad06"]="Panel 3 (v4)"
    ["f6984db1b07f03a90c182c59dd51ccf0"]="Panel 3 (v4)"
    ["7b76c4e4333887fd0ccc0afddd2f41ce"]="Panel 4"
    ["4863e7544738df62eaae4a1bec031fd9"]="Panel 4"
    ["5871fde00d2ed1e5866665e38ee3cfab"]="Panel 4"
    ["b92e8d791dec428b65ad52ccc5a17af4"]="Panel 4"
    ["8faf0a3873008548c55dfff574b2a3f9"]="Panel 4"
    ["42a3021377abadd36375e62a7d5a2e40"]="Panel 4"
    ["c4547ce22eca3c318546f3cbf5f3d878"]="Panel 4"
    ["5f4dcc3b5aa765d61d8327deb882cf99"]="Panel 4"
    ["861278f7ab7ade97ac1515aedbbdeff0"]="Panel 5"
    ["6cb75f652a9b52798eb6cf2201057c73"]="Panel 5"
    ["7c6a180b36896a0a8c02787eeafb0e4c"]="Panel 6"
      ["8e296a067a37563370ded05f5b48b8e2"]="Panel 7"
      ["9a1158154dfa42caddbd0691a4a1d4e2"]="Panel 8"
      ["a4b0e6c8e5e7a8b8e8a9e8e8e8e8e8e8"]="Panel 9"
      ["b6d81e3b1f9e5b7b8a8b8b8b8b8b8b8b"]="Panel 10"
      ["df50e4c1847859cc94f7e6d3e4951e15"]="Clone EmuELEC"
    ["d11822d1a383b789e9d1e433434199c1"]="Clone Panel BOE"
      ["f1d93c6f4922378c523455b85d99c431"]="Clone Panel TCL"
      ["00713570643bf415257903450e64c127"]="Clone Panel BOE v2"
      ["c8431871343f7f02d7515e06b3a2a6b4"]="Clone"
      ["453a2588c227708573299c85532f36f3"]="Clone Panel Powkiddy RGB20S"
      ["a2345e6912389d5386e8e202951f33f3"]="Clone Panel 0"
      ["7b2671239c06632c02c918a04b19280f"]="Clone Panel 1"
      ["8959d5718eb29c15b13bb222956c2d1b"]="Clone Panel 2"
      ["a82e850450531bd2859066601f016556"]="Clone Panel 3"
      ["09f7a26f68c346ac791097e3666e13b8"]="Clone Panel 4"
      ["770554e2095908b981297e68e420de98"]="Clone Panel 5"
    )

    # Vérifixation chaque DTB
    for DTB_FILE in $DTB_FILES; do
        HASH=$(md5sum "$DTB_FILE" | awk '{print $1}')
        if [[ -n "${dtb_md5[$HASH]}" ]]; then
            echo "${dtb_md5[$HASH]}"
            return 0
        fi
    done

    # Si aucun panel n'est détecté
    echo "Unknown panel"
    return 1
}

# --- Infos SD  ---
GetSDInfo() {
    local LABEL=$1
    local MOUNTPOINT=$2

    local DEV=$(lsblk -no pkname $(findmnt -n -o SOURCE "$MOUNTPOINT") 2>/dev/null | head -n1)
    if [ -z "$DEV" ]; then
        echo "  • Not inserted"
        return
    fi

    # Taille totale de la carte SD (toutes partitions)
    local TOTAL=$(lsblk -b -dn -o SIZE "/dev/$DEV" | awk '{s+=$1} END {print s}')
    local TOTAL_GB=$(awk "BEGIN {printf \"%.2f\", $TOTAL/1024/1024/1024}")

    # Occupé et disponible 
    local USED=0
    local AVAIL=0
    for part in $(lsblk -ln -o NAME "/dev/$DEV"); do
        local MP=$(lsblk -ln -o MOUNTPOINT "/dev/$part")
        [[ "$MP" == "/boot" ]] && continue
        if [ -n "$MP" ]; then
            USED_PART=$(df -B1 --output=used "$MP" | tail -1)
            AVAIL_PART=$(df -B1 --output=avail "$MP" | tail -1)
            USED=$((USED + USED_PART))
            AVAIL=$((AVAIL + AVAIL_PART))
        fi
    done
    local USED_GB=$(awk "BEGIN {printf \"%.2f\", $USED/1024/1024/1024}")
    local AVAIL_GB=$(awk "BEGIN {printf \"%.2f\", $AVAIL/1024/1024/1024}")

    echo "  • Total SD size : ${TOTAL_GB} GB"
    echo "  • Used : ${USED_GB} GB"
    echo "  • Available : ${AVAIL_GB} GB"
}

# --- Affichage infos ---
ShowInfos() {
    setfont /usr/share/consolefonts/Lat7-Terminus16.psf.gz
    PANEL_VERSION=$(DetectPanel)

    MEM_TOTAL_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    MEM_AVAILABLE_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    MEM_TOTAL=$(awk "BEGIN {printf \"%.0f MB\", $MEM_TOTAL_KB/1024}")
    MEM_AVAILABLE=$(awk "BEGIN {printf \"%.0f MB\", $MEM_AVAILABLE_KB/1024}")
    MEM_USED=$(awk "BEGIN {printf \"%.0f MB\", ($MEM_TOTAL_KB - $MEM_AVAILABLE_KB)/1024}")

    SD1_INFO=$(GetSDInfo "SD1" "/roms")
    SD2_INFO=$(GetSDInfo "SD2" "/roms2")

    if [ -f /home/ark/.config/.VERSION ]; then
        read -r ARK_VERSION < /home/ark/.config/.VERSION
    else
        ARK_VERSION="Unknown"
    fi

    dialog --backtitle "$APP_NAME" --title "Console Information" --msgbox "\
    
-------------------Display---------------------
  • Detected panel : $PANEL_VERSION

-------------------Memory----------------------
  • Total       : $MEM_TOTAL
  • Used        : $MEM_USED
  • Available   : $MEM_AVAILABLE

-------------------SD Card 1-------------------
$SD1_INFO

-------------------SD Card 2-------------------
$SD2_INFO

-------------------System----------------------
  • ArkOS Version : $ARK_VERSION
" 25 51 > $CURR_TTY
}

# --- Lancement clean ---
sudo chmod 666 $CURR_TTY
printf "\e[?25l" > $CURR_TTY
clear > $CURR_TTY
dialog --clear
trap ExitMenu EXIT

sudo chmod 666 /dev/uinput
export SDL_GAMECONTROLLERCONFIG_FILE="/opt/inttools/gamecontrollerdb.txt"
pgrep -f gptokeyb | sudo xargs kill -9 2>/dev/null
/opt/inttools/gptokeyb -1 "InfoSystem.sh" -c "/opt/inttools/keys.gptk" > /dev/null 2>&1 &

ShowInfos