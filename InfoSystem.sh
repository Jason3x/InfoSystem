#!/bin/bash
#--------------------------------#
# Script Infos R36S - ArkOS AeUX #
#--------------------------------#

if [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$0" "$@"
fi

CURR_TTY="/dev/tty1"
APP_NAME="R36S System Info v2.0 by Jason & lcdyk"

printf "\033c" > "$CURR_TTY"
printf "\e[?25l" > "$CURR_TTY"
dialog --clear
export TERM=linux
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Police adaptée selon présence joystick
if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    setfont /usr/share/consolefonts/Lat7-TerminusBold16.psf.gz
else
    setfont /usr/share/consolefonts/Lat7-Terminus20x10.psf.gz
fi

pkill -9 -f gptokeyb || true
pkill -9 -f osk.py || true

printf "\033c" > "$CURR_TTY"
printf "Starting Info System v2.0\nPlease wait..." > "$CURR_TTY"
sleep 1

ExitMenu() {
    printf "\033c" > "$CURR_TTY"
    printf "\e[?25h" > "$CURR_TTY"
    pkill -f "gptokeyb -1 InfoSystem.sh" || true
    if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
        setfont /usr/share/consolefonts/Lat7-Terminus20x10.psf.gz
    fi
    exit 0
}

# ========= 设备数据库：面板初始化序列 + reset-gpio =========
declare -Ag device_name
declare -Ag device_panel_seq
declare -Ag device_reset

# type 1
device_name["type1"]="Clone R36S Type 1"
device_panel_seq["type1"]="39 00 04 b9 f1 12 83 39 00 06 b1 00 00 00 da 80 39 00 04 b2 00 13 70 39 00 0b b3 10 10 28 28 03 ff 00 00 00 00 15 00 02 b4 80 15 00 03 b5 0a 0a 15 00 03 b6 82 82 39 00 05 b8 26 62 f0 63 39 00 1c ba 33 81 05 f9 0e 0e 20 00 00 00 00 00 00 00 44 25 00 90 0a 00 00 01 4f 01 00 00 37 15 00 02 bc 47 39 00 04 bf 02 11 00 39 00 0a c0 73 73 50 50 00 00 12 50 00 39 00 0d c1 53 00 32 32 77 d1 cc cc 77 77 33 33 39 00 07 c6 82 00 bf ff 00 ff 39 00 07 c7 b8 00 0a 00 00 00 39 00 05 c8 10 40 1e 02 15 00 02 cc 0b 39 00 23 e0 00 07 0d 37 35 3f 41 44 06 0c 0d 0f 11 10 12 14 1a 00 07 0d 37 35 3f 41 44 06 0c 0d 0f 11 10 12 14 1a 39 00 0f e3 07 07 0b 0b 0b 0b 00 00 00 00 ff 00 c0 10 39 00 40 e9 c8 10 02 00 00 b0 b1 11 31 23 28 80 b0 b1 27 08 00 04 02 00 00 00 00 04 02 00 00 00 88 88 ba 60 24 08 88 88 88 88 88 88 88 ba 71 35 18 88 88 88 88 88 00 00 00 01 00 00 00 00 00 00 00 00 00 39 00 3e ea 97 0a 82 02 03 07 00 00 00 00 00 00 81 88 ba 17 53 88 88 88 88 88 88 80 88 ba 06 42 88 88 88 88 88 88 23 00 00 02 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 39 00 04 ef ff ff 01 05 c8 01 11 05 14 01 29"
device_reset["type1"]="&gpio3 RK_PB7 GPIO_ACTIVE_LOW"

# type 2
device_name["type2"]="Clone R36S Type 2"
device_panel_seq["type2"]="39 00 04 b9 f1 12 83 39 00 06 b1 00 00 00 da 80 39 00 04 b2 00 13 70 39 00 0b b3 10 10 28 28 03 ff 00 00 00 00 15 00 02 b4 80 15 00 03 b5 0a 0a 15 00 03 b6 82 82 39 00 05 b8 26 62 f0 63 39 00 1c ba 33 81 05 f9 0e 0e 20 00 00 00 00 00 00 00 44 25 00 90 0a 00 00 01 4f 01 00 00 37 15 00 02 bc 47 39 00 04 bf 02 11 00 39 00 0a c0 73 73 50 50 00 00 12 50 00 39 00 0d c1 53 00 32 32 77 d1 cc cc 77 77 33 33 39 00 07 c6 82 00 bf ff 00 ff 39 00 07 c7 b8 00 0a 00 00 00 39 00 05 c8 10 40 1e 02 15 00 02 cc 0b 39 00 23 e0 00 07 0d 37 35 3f 41 44 06 0c 0d 0f 11 10 12 14 1a 00 07 0d 37 35 3f 41 44 06 0c 0d 0f 11 10 12 14 1a 39 00 0f e3 07 07 0b 0b 0b 0b 00 00 00 00 ff 00 c0 10 39 00 40 e9 c8 10 02 00 00 b0 b1 11 31 23 28 80 b0 b1 27 08 00 04 02 00 00 00 00 04 02 00 00 00 88 88 ba 60 24 08 88 88 88 88 88 88 88 ba 71 35 18 88 88 88 88 88 00 00 00 01 00 00 00 00 00 00 00 00 00 39 00 3e ea 97 0a 82 02 03 07 00 00 00 00 00 00 81 88 ba 17 53 88 88 88 88 88 88 80 88 ba 06 42 88 88 88 88 88 88 23 00 00 02 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 39 00 04 ef ff ff 01 05 c8 01 11 05 14 01 29"
device_reset["type2"]="&gpio3 RK_PD3 GPIO_ACTIVE_LOW"

# type 3
device_name["type3"]="Clone R36S Type 3"
device_panel_seq["type3"]="15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 01 15 00 02 e3 00 15 00 02 25 10 15 00 02 28 6f 15 00 02 29 01 15 00 02 2a df 15 00 02 2c 22 15 00 02 c3 0f 15 00 02 37 9c 15 00 02 38 a7 15 00 02 39 41 15 00 02 80 20 15 00 02 91 67 15 00 02 92 67 15 00 02 a0 55 15 00 02 a1 50 15 00 02 a3 58 15 00 02 a4 9c 15 00 02 a7 02 15 00 02 a8 01 15 00 02 a9 21 15 00 02 aa fc 15 00 02 ab 28 15 00 02 ac 06 15 00 02 ad 06 15 00 02 ae 06 15 00 02 af 03 15 00 02 b0 08 15 00 02 b1 26 15 00 02 b2 28 15 00 02 b3 28 15 00 02 b4 03 15 00 02 b5 08 15 00 02 b6 26 15 00 02 b7 08 15 00 02 b8 26 15 00 02 c0 00 15 00 02 c1 00 15 00 02 c2 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 b0 02 15 00 02 d0 02 15 00 02 b1 0f 15 00 02 d1 10 15 00 02 b2 11 15 00 02 d2 12 15 00 02 b3 32 15 00 02 d3 33 15 00 02 b4 36 15 00 02 d4 36 15 00 02 b5 3c 15 00 02 d5 3c 15 00 02 b6 20 15 00 02 d6 20 15 00 02 b7 3e 15 00 02 d7 3e 15 00 02 b8 0e 15 00 02 d8 0d 15 00 02 b9 05 15 00 02 d9 05 15 00 02 ba 11 15 00 02 da 12 15 00 02 bb 11 15 00 02 db 11 15 00 02 bc 13 15 00 02 dc 14 15 00 02 bd 14 15 00 02 dd 14 15 00 02 be 16 15 00 02 de 18 15 00 02 bf 0e 15 00 02 df 0f 15 00 02 c0 17 15 00 02 e0 17 15 00 02 c1 07 15 00 02 e1 08 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 03 15 00 02 08 8a 15 00 02 09 8b 15 00 02 30 00 15 00 02 31 00 15 00 02 32 00 15 00 02 33 00 15 00 02 34 61 15 00 02 35 d4 15 00 02 36 24 15 00 02 37 03 15 00 02 40 86 15 00 02 41 87 15 00 02 42 84 15 00 02 43 85 15 00 02 44 11 15 00 02 45 de 15 00 02 46 dd 15 00 02 47 11 15 00 02 48 e0 15 00 02 49 df 15 00 02 50 82 15 00 02 51 83 15 00 02 52 80 15 00 02 53 81 15 00 02 54 11 15 00 02 55 e2 15 00 02 56 e1 15 00 02 57 11 15 00 02 58 e4 15 00 02 59 e3 15 00 02 82 0f 15 00 02 83 0f 15 00 02 84 00 15 00 02 85 0f 15 00 02 86 0f 15 00 02 87 0e 15 00 02 88 0e 15 00 02 89 06 15 00 02 8a 06 15 00 02 8b 07 15 00 02 8c 07 15 00 02 8d 04 15 00 02 8e 04 15 00 02 8f 05 15 00 02 90 05 15 00 02 98 0f 15 00 02 99 0f 15 00 02 9a 00 15 00 02 9b 0f 15 00 02 9c 0f 15 00 02 9d 0e 15 00 02 9e 0e 15 00 02 9f 06 15 00 02 a0 06 15 00 02 a1 07 15 00 02 a2 07 15 00 02 a3 04 15 00 02 a4 04 15 00 02 a5 05 15 00 02 a6 05 15 00 02 e0 02 15 00 02 e1 52 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 00 15 00 02 36 02 05 c8 01 11 05 64 01 29"
device_reset["type3"]="&gpio3 RK_PB7 GPIO_ACTIVE_LOW"

# type 4
device_name["type4"]="Clone R36S Type 4"
device_panel_seq["type4"]="39 00 04 b9 f1 12 87 39 00 04 b2 78 04 70 39 00 0b b3 10 10 fc fc 03 ff 00 00 00 00 15 00 02 b4 80 15 00 03 b5 06 06 15 00 03 b6 a9 a9 39 00 05 b8 26 22 f0 13 39 00 1c ba 33 81 05 f9 0e 0e 20 00 00 00 00 00 00 00 44 25 00 91 0a 00 00 01 4f 01 00 00 37 39 00 02 bc 47 39 00 06 bf 02 10 00 80 04 39 00 0a c0 73 73 50 50 00 00 12 73 00 39 00 12 c1 25 c0 32 32 99 e4 77 77 cc cc ff ff 11 11 00 00 32 39 00 0d c7 10 00 0a 00 00 00 00 00 ed c5 00 a5 39 00 05 c8 10 40 1e 03 39 00 02 cc 0b 39 00 23 e0 00 0a 0f 29 3c 3f 41 38 08 0c 0f 12 14 12 13 12 19 00 0a 0f 29 3c 3f 41 38 08 0c 0f 12 14 12 13 12 19 39 00 08 e1 11 11 91 00 00 00 00 39 00 0f e3 07 07 0b 0b 0b 0b 00 00 00 00 ff 04 c0 10 39 00 40 e9 c8 10 0a 00 00 f0 81 12 31 23 4f 86 f0 81 47 08 00 00 10 00 00 00 00 00 10 00 00 00 88 88 08 f8 f4 46 60 02 28 88 88 88 88 18 f8 f5 57 71 13 38 88 88 00 00 00 01 00 00 00 00 00 00 00 00 00 39 00 3e ea 00 1a 00 00 00 00 00 00 00 00 00 00 88 f8 18 f8 83 31 17 75 58 88 88 88 f8 08 f8 82 20 06 64 48 88 88 23 00 00 02 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 39 00 04 ef ff ff 01 05 fa 01 11 05 32 01 29"
device_reset["type4"]="&gpio3 RK_PB7 GPIO_ACTIVE_LOW"

# type 5
device_name["type5"]="Clone R36S Type 5"
device_panel_seq["type5"]="15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 01 15 00 02 e3 00 15 00 02 25 10 15 00 02 28 6f 15 00 02 29 01 15 00 02 2a df 15 00 02 2c 22 15 00 02 c3 0f 15 00 02 37 9c 15 00 02 38 a7 15 00 02 39 41 15 00 02 80 20 15 00 02 91 67 15 00 02 92 67 15 00 02 a0 55 15 00 02 a1 50 15 00 02 a3 58 15 00 02 a4 9c 15 00 02 a7 02 15 00 02 a8 01 15 00 02 a9 21 15 00 02 aa fc 15 00 02 ab 28 15 00 02 ac 06 15 00 02 ad 06 15 00 02 ae 06 15 00 02 af 03 15 00 02 b0 08 15 00 02 b1 26 15 00 02 b2 28 15 00 02 b3 28 15 00 02 b4 03 15 00 02 b5 08 15 00 02 b6 26 15 00 02 b7 08 15 00 02 b8 26 15 00 02 c0 00 15 00 02 c1 00 15 00 02 c2 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 b0 02 15 00 02 d0 02 15 00 02 b1 0f 15 00 02 d1 10 15 00 02 b2 11 15 00 02 d2 12 15 00 02 b3 32 15 00 02 d3 33 15 00 02 b4 36 15 00 02 d4 36 15 00 02 b5 3c 15 00 02 d5 3c 15 00 02 b6 20 15 00 02 d6 20 15 00 02 b7 3e 15 00 02 d7 3e 15 00 02 b8 0e 15 00 02 d8 0d 15 00 02 b9 05 15 00 02 d9 05 15 00 02 ba 11 15 00 02 da 12 15 00 02 bb 11 15 00 02 db 11 15 00 02 bc 13 15 00 02 dc 14 15 00 02 bd 14 15 00 02 dd 14 15 00 02 be 16 15 00 02 de 18 15 00 02 bf 0e 15 00 02 df 0f 15 00 02 c0 17 15 00 02 e0 17 15 00 02 c1 07 15 00 02 e1 08 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 03 15 00 02 08 8a 15 00 02 09 8b 15 00 02 30 00 15 00 02 31 00 15 00 02 32 00 15 00 02 33 00 15 00 02 34 61 15 00 02 35 d4 15 00 02 36 24 15 00 02 37 03 15 00 02 40 86 15 00 02 41 87 15 00 02 42 84 15 00 02 43 85 15 00 02 44 11 15 00 02 45 de 15 00 02 46 dd 15 00 02 47 11 15 00 02 48 e0 15 00 02 49 df 15 00 02 50 82 15 00 02 51 83 15 00 02 52 80 15 00 02 53 81 15 00 02 54 11 15 00 02 55 e2 15 00 02 56 e1 15 00 02 57 11 15 00 02 58 e4 15 00 02 59 e3 15 00 02 82 0f 15 00 02 83 0f 15 00 02 84 00 15 00 02 85 0f 15 00 02 86 0f 15 00 02 87 0e 15 00 02 88 0e 15 00 02 89 06 15 00 02 8a 06 15 00 02 8b 07 15 00 02 8c 07 15 00 02 8d 04 15 00 02 8e 04 15 00 02 8f 05 15 00 02 90 05 15 00 02 98 0f 15 00 02 99 0f 15 00 02 9a 00 15 00 02 9b 0f 15 00 02 9c 0f 15 00 02 9d 0e 15 00 02 9e 0e 15 00 02 9f 06 15 00 02 a0 06 15 00 02 a1 07 15 00 02 a2 07 15 00 02 a3 04 15 00 02 a4 04 15 00 02 a5 05 15 00 02 a6 05 15 00 02 e0 02 15 00 02 e1 52 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 00 15 00 02 36 02 05 c8 01 11 05 64 01 29"
device_reset["type5"]="&gpio3 RK_PD3 GPIO_ACTIVE_LOW"

# Original0
device_name["orgin0"]="Originalal R36S Panel 0"
device_panel_seq["orgin0"]="39 00 04 b9 f1 12 83 39 00 06 b1 00 00 00 da 80 39 00 04 b2 00 13 70 39 00 0b b3 10 10 28 28 03 ff 00 00 00 00 15 00 02 b4 80 15 00 03 b5 0a 0a 15 00 03 b6 7f 7f 39 00 05 b8 26 62 f0 63 39 00 1c ba 33 81 05 f9 0e 0e 20 00 00 00 00 00 00 00 44 25 00 90 0a 00 00 01 4f 01 00 00 37 15 00 02 bc 47 39 00 04 bf 02 11 00 39 00 0a c0 73 73 50 50 00 00 12 50 00 39 00 0d c1 53 c0 32 32 77 e1 dd dd 77 77 33 33 39 00 07 c6 82 00 bf ff 00 ff 39 00 07 c7 b8 00 0a 00 00 00 39 00 05 c8 10 40 1e 02 15 00 02 cc 0b 39 00 23 e0 00 07 0d 37 35 3f 41 44 06 0c 0d 0f 11 10 12 14 1a 00 07 0d 37 35 3f 41 44 06 0c 0d 0f 11 10 12 14 1a 39 00 0f e3 07 07 0b 0b 0b 0b 00 00 00 00 ff 00 c0 10 39 00 40 e9 c8 10 02 00 00 b0 b1 11 31 23 28 80 b0 b1 27 08 00 04 02 00 00 00 00 04 02 00 00 00 88 88 ba 60 24 08 88 88 88 88 88 88 88 ba 71 35 18 88 88 88 88 88 00 00 00 01 00 00 00 00 00 00 00 00 00 39 00 3e ea 97 0a 82 02 03 07 00 00 00 00 00 00 81 88 ba 17 53 88 88 88 88 88 88 80 88 ba 06 42 88 88 88 88 88 88 23 00 00 02 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 39 00 04 ef ff ff 01 05 c8 01 11 05 32 01 29"
device_reset["orgin0"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# Original1
device_name["orgin1"]="Original R36S Panel 1"
device_panel_seq["orgin1"]="39 00 03 e0 ab ba 39 00 03 e1 ba ab 39 00 05 b1 10 01 47 ff 39 00 07 b2 0c 08 04 50 50 14 39 00 04 b3 56 12 e0 39 00 04 b4 33 30 04 39 00 08 b6 b0 00 00 10 00 10 00 39 00 06 b8 05 12 29 49 48 39 00 27 b9 7f 63 52 45 42 34 39 24 3e 3d 3c 59 46 4d 3e 3d 30 22 00 7f 63 52 45 42 34 39 24 3e 3d 3c 59 46 4d 3e 3d 30 22 00 39 00 11 c0 32 10 12 34 22 22 22 22 90 04 90 04 0f 00 00 c1 39 00 0b c1 12 9f 8e 89 90 04 90 04 54 40 39 00 0d c2 77 09 08 89 08 11 22 33 44 87 18 00 39 00 17 c3 88 4a 24 24 1e 1f 12 0c 0e 10 04 06 24 24 02 02 02 02 02 02 02 02 39 00 17 c4 09 0b 24 24 1e 1f 13 0d 0f 11 05 07 24 24 02 02 02 02 02 02 02 02 39 00 03 c6 46 55 39 00 07 c8 12 00 31 42 34 16 39 00 03 ca 18 43 39 00 09 cd 0e 64 64 2c 16 6b 06 b3 39 00 05 d2 e3 2b 38 08 39 00 0c d4 00 01 00 0e 04 44 08 10 00 00 00 39 00 09 e6 80 09 ff ff ff ff ff ff 39 00 06 f0 12 03 20 00 ff 15 00 02 f3 03 05 c8 01 11 05 14 01 29"
device_reset["orgin1"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# Original2
device_name["orgin2"]="Original R36S Panel 2"
device_panel_seq["orgin2"]="15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 01 15 00 02 e3 00 15 00 02 40 0a 15 00 02 03 40 15 00 02 04 00 15 00 02 05 03 15 00 02 24 12 15 00 02 25 1e 15 00 02 26 6f 15 00 02 27 52 15 00 02 28 67 15 00 02 29 01 15 00 02 2a df 15 00 02 37 9c 15 00 02 38 a7 15 00 02 39 53 15 00 02 44 00 15 00 02 49 3c 15 00 02 59 fe 15 00 02 5c 00 15 00 02 80 20 15 00 02 91 77 15 00 02 92 77 15 00 02 a0 55 15 00 02 a1 50 15 00 02 a4 9c 15 00 02 a7 02 15 00 02 a8 01 15 00 02 a9 21 15 00 02 aa fc 15 00 02 ab 28 15 00 02 ac 06 15 00 02 ad 06 15 00 02 ae 06 15 00 02 af 03 15 00 02 b0 08 15 00 02 b1 26 15 00 02 b2 28 15 00 02 b3 28 15 00 02 b4 33 15 00 02 b5 08 15 00 02 b6 26 15 00 02 b7 08 15 00 02 b8 26 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 b0 0b 15 00 02 b1 16 15 00 02 b2 17 15 00 02 b3 2c 15 00 02 b4 32 15 00 02 b5 3b 15 00 02 b6 29 15 00 02 b7 40 15 00 02 b8 0d 15 00 02 b9 05 15 00 02 ba 12 15 00 02 bb 10 15 00 02 bc 12 15 00 02 bd 15 15 00 02 be 19 15 00 02 bf 0e 15 00 02 c0 16 15 00 02 c1 0a 15 00 02 d0 0c 15 00 02 d1 17 15 00 02 d2 14 15 00 02 d3 2e 15 00 02 d4 32 15 00 02 d5 3c 15 00 02 d6 22 15 00 02 d7 3d 15 00 02 d8 0d 15 00 02 d9 07 15 00 02 da 13 15 00 02 db 13 15 00 02 dc 11 15 00 02 dd 15 15 00 02 de 19 15 00 02 df 10 15 00 02 e0 17 15 00 02 e1 0a 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 03 15 00 02 00 2a 15 00 02 01 2a 15 00 02 02 2a 15 00 02 03 2a 15 00 02 04 61 15 00 02 05 80 15 00 02 06 c7 15 00 02 07 01 15 00 02 08 82 15 00 02 09 83 15 00 02 30 2a 15 00 02 31 2a 15 00 02 32 2a 15 00 02 33 2a 15 00 02 34 a1 15 00 02 35 c5 15 00 02 36 80 15 00 02 37 23 15 00 02 40 82 15 00 02 41 83 15 00 02 42 80 15 00 02 43 81 15 00 02 44 55 15 00 02 45 e6 15 00 02 46 e5 15 00 02 47 55 15 00 02 48 e8 15 00 02 49 e7 15 00 02 50 02 15 00 02 51 01 15 00 02 52 04 15 00 02 53 03 15 00 02 54 55 15 00 02 55 ea 15 00 02 56 e9 15 00 02 57 55 15 00 02 58 ec 15 00 02 59 eb 15 00 02 7e 02 15 00 02 7f 80 15 00 02 e0 5a 15 00 02 b1 00 15 00 02 b4 0e 15 00 02 b5 0f 15 00 02 b6 04 15 00 02 b7 07 15 00 02 b8 06 15 00 02 b9 05 15 00 02 ba 0f 15 00 02 c7 00 15 00 02 ca 0e 15 00 02 cb 0f 15 00 02 cc 04 15 00 02 cd 07 15 00 02 ce 06 15 00 02 cf 05 15 00 02 d0 0f 15 00 02 81 0f 15 00 02 84 0e 15 00 02 85 0f 15 00 02 86 07 15 00 02 87 04 15 00 02 88 05 15 00 02 89 06 15 00 02 8a 00 15 00 02 97 0f 15 00 02 9a 0e 15 00 02 9b 0f 15 00 02 9c 07 15 00 02 9d 04 15 00 02 9e 05 15 00 02 9f 06 15 00 02 a0 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 01 01 15 00 02 02 da 15 00 02 03 ba 15 00 02 04 a8 15 00 02 05 9a 15 00 02 06 70 15 00 02 07 ff 15 00 02 08 91 15 00 02 09 90 15 00 02 0a ff 15 00 02 0b 8f 15 00 02 0c 60 15 00 02 0d 58 15 00 02 0e 48 15 00 02 0f 38 15 00 02 10 2b 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 00 15 00 02 36 02 15 00 02 3a 70 05 c8 01 11 05 14 01 29"
device_reset["orgin2"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# origin3
device_name["orgin3"]="Original R36S Panel 3"
device_panel_seq["orgin3"]="15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 01 15 00 02 e3 00 15 00 02 04 00 15 00 02 05 03 15 00 02 24 12 15 00 02 25 1e 15 00 02 26 6f 15 00 02 27 52 15 00 02 28 67 15 00 02 29 01 15 00 02 2a df 15 00 02 37 9c 15 00 02 38 a7 15 00 02 39 53 15 00 02 44 00 15 00 02 49 3c 15 00 02 59 fe 15 00 02 5c 00 15 00 02 80 20 15 00 02 91 77 15 00 02 92 77 15 00 02 a0 55 15 00 02 a1 50 15 00 02 a4 9c 15 00 02 a7 02 15 00 02 a8 01 15 00 02 a9 21 15 00 02 aa fc 15 00 02 ab 28 15 00 02 ac 06 15 00 02 ad 06 15 00 02 ae 06 15 00 02 af 03 15 00 02 b0 08 15 00 02 b1 26 15 00 02 b2 28 15 00 02 b3 28 15 00 02 b4 33 15 00 02 b5 08 15 00 02 b6 26 15 00 02 b7 08 15 00 02 b8 26 15 00 02 c0 00 15 00 02 c1 00 15 00 02 c2 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 b0 0b 15 00 02 b1 16 15 00 02 b2 17 15 00 02 b3 2c 15 00 02 b4 32 15 00 02 b5 3b 15 00 02 b6 29 15 00 02 b7 40 15 00 02 b8 0d 15 00 02 b9 05 15 00 02 ba 12 15 00 02 bb 10 15 00 02 bc 12 15 00 02 bd 15 15 00 02 be 19 15 00 02 bf 0e 15 00 02 c0 16 15 00 02 c1 0a 15 00 02 d0 0c 15 00 02 d1 17 15 00 02 d2 14 15 00 02 d3 2e 15 00 02 d4 32 15 00 02 d5 3c 15 00 02 d6 22 15 00 02 d7 3d 15 00 02 d8 0d 15 00 02 d9 07 15 00 02 da 13 15 00 02 db 13 15 00 02 dc 11 15 00 02 dd 15 15 00 02 de 19 15 00 02 df 10 15 00 02 e0 17 15 00 02 e1 0a 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 03 15 00 02 00 2a 15 00 02 01 2a 15 00 02 02 2a 15 00 02 03 2a 15 00 02 04 61 15 00 02 05 80 15 00 02 06 c7 15 00 02 07 01 15 00 02 08 82 15 00 02 09 83 15 00 02 30 2a 15 00 02 31 2a 15 00 02 32 2a 15 00 02 33 2a 15 00 02 34 a1 15 00 02 35 c5 15 00 02 36 80 15 00 02 37 23 15 00 02 40 82 15 00 02 41 83 15 00 02 42 80 15 00 02 43 81 15 00 02 44 55 15 00 02 45 e6 15 00 02 46 e5 15 00 02 47 55 15 00 02 48 e8 15 00 02 49 e7 15 00 02 50 02 15 00 02 51 01 15 00 02 52 04 15 00 02 53 03 15 00 02 54 55 15 00 02 55 ea 15 00 02 56 e9 15 00 02 57 55 15 00 02 58 ec 15 00 02 59 eb 15 00 02 7e 02 15 00 02 7f 80 15 00 02 e0 5a 15 00 02 b1 00 15 00 02 b4 0e 15 00 02 b5 0f 15 00 02 b6 04 15 00 02 b7 07 15 00 02 b8 06 15 00 02 b9 05 15 00 02 ba 0f 15 00 02 c7 00 15 00 02 ca 0e 15 00 02 cb 0f 15 00 02 cc 04 15 00 02 cd 07 15 00 02 ce 06 15 00 02 cf 05 15 00 02 d0 0f 15 00 02 81 0f 15 00 02 84 0e 15 00 02 85 0f 15 00 02 86 07 15 00 02 87 04 15 00 02 88 05 15 00 02 89 06 15 00 02 8a 00 15 00 02 97 0f 15 00 02 9a 0e 15 00 02 9b 0f 15 00 02 9c 07 15 00 02 9d 04 15 00 02 9e 05 15 00 02 9f 06 15 00 02 a0 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 01 01 15 00 02 02 da 15 00 02 03 ba 15 00 02 04 a8 15 00 02 05 9a 15 00 02 06 70 15 00 02 07 ff 15 00 02 08 91 15 00 02 09 90 15 00 02 0a ff 15 00 02 0b 8f 15 00 02 0c 60 15 00 02 0d 58 15 00 02 0e 48 15 00 02 0f 38 15 00 02 10 2b 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 00 15 00 02 36 02 15 00 02 3a 70 05 c8 01 11 05 14 01 29"
device_reset["orgin3"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# origin4
device_name["orgin4"]="Original R36S Panel 4"
device_panel_seq["orgin4"]="15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 01 15 00 02 e3 00 15 00 02 25 10 15 00 02 28 6f 15 00 02 29 01 15 00 02 2a df 15 00 02 2c 22 15 00 02 c3 0f 15 00 02 37 9c 15 00 02 38 a7 15 00 02 39 41 15 00 02 80 20 15 00 02 91 67 15 00 02 92 67 15 00 02 a0 55 15 00 02 a1 50 15 00 02 a3 58 15 00 02 a4 9c 15 00 02 a7 02 15 00 02 a8 01 15 00 02 a9 21 15 00 02 aa fc 15 00 02 ab 28 15 00 02 ac 06 15 00 02 ad 06 15 00 02 ae 06 15 00 02 af 03 15 00 02 b0 08 15 00 02 b1 26 15 00 02 b2 28 15 00 02 b3 28 15 00 02 b4 03 15 00 02 b5 08 15 00 02 b6 26 15 00 02 b7 08 15 00 02 b8 26 15 00 02 2c 22 15 00 02 5c 40 15 00 02 c0 00 15 00 02 c1 00 15 00 02 c2 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 b0 02 15 00 02 d0 02 15 00 02 b1 0f 15 00 02 d1 10 15 00 02 b2 11 15 00 02 d2 12 15 00 02 b3 32 15 00 02 d3 33 15 00 02 b4 36 15 00 02 d4 36 15 00 02 b5 3c 15 00 02 d5 3c 15 00 02 b6 20 15 00 02 d6 20 15 00 02 b7 3e 15 00 02 d7 3e 15 00 02 b8 0e 15 00 02 d8 0d 15 00 02 b9 05 15 00 02 d9 05 15 00 02 ba 11 15 00 02 da 12 15 00 02 bb 11 15 00 02 db 11 15 00 02 bc 13 15 00 02 dc 14 15 00 02 bd 14 15 00 02 dd 14 15 00 02 be 16 15 00 02 de 18 15 00 02 bf 0e 15 00 02 df 0f 15 00 02 c0 17 15 00 02 e0 17 15 00 02 c1 07 15 00 02 e1 08 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 03 15 00 02 08 8a 15 00 02 09 8b 15 00 02 30 00 15 00 02 31 00 15 00 02 32 00 15 00 02 33 00 15 00 02 34 61 15 00 02 35 d4 15 00 02 36 24 15 00 02 37 03 15 00 02 40 86 15 00 02 41 87 15 00 02 42 84 15 00 02 43 85 15 00 02 44 11 15 00 02 45 de 15 00 02 46 dd 15 00 02 47 11 15 00 02 48 e0 15 00 02 49 df 15 00 02 50 82 15 00 02 51 83 15 00 02 52 80 15 00 02 53 81 15 00 02 54 11 15 00 02 55 e2 15 00 02 56 e1 15 00 02 57 11 15 00 02 58 e4 15 00 02 59 e3 15 00 02 82 0f 15 00 02 83 0f 15 00 02 84 00 15 00 02 85 0f 15 00 02 86 0f 15 00 02 87 0e 15 00 02 88 0e 15 00 02 89 06 15 00 02 8a 06 15 00 02 8b 07 15 00 02 8c 07 15 00 02 8d 04 15 00 02 8e 04 15 00 02 8f 05 15 00 02 90 05 15 00 02 98 0f 15 00 02 99 0f 15 00 02 9a 00 15 00 02 9b 0f 15 00 02 9c 0f 15 00 02 9d 0e 15 00 02 9e 0e 15 00 02 9f 06 15 00 02 a0 06 15 00 02 a1 07 15 00 02 a2 07 15 00 02 a3 04 15 00 02 a4 04 15 00 02 a5 05 15 00 02 a6 05 15 00 02 e0 02 15 00 02 e1 52 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 00 15 00 02 36 02 15 00 02 11 00 15 00 02 29 00 05 c8 01 11 05 14 01 29"
device_reset["orgin4"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# Soy Sauce V03
device_name["soysauce03"]="SoySauce R36S V03"
device_panel_seq["soysauce03"]="39 00 04 b9 f1 12 83 39 00 1c ba 33 81 05 f9 0e 0e 20 00 00 00 00 00 00 00 44 25 00 91 0a 00 00 02 4f d1 00 00 37 15 00 02 b8 25 39 00 04 bf 02 11 00 39 00 0b b3 0c 10 0a 50 03 ff 00 00 00 00 39 00 0a c0 73 73 50 50 00 00 08 70 00 15 00 02 bc 46 15 00 02 cc 0b 15 00 02 b4 80 39 00 04 b2 00 13 f0 39 00 0f e3 07 07 0b 0b 03 0b 00 00 00 00 ff 00 c0 10 39 00 0d c1 53 00 1e 1e 77 e1 cc dd 67 77 33 33 39 00 03 b5 10 10 39 00 03 b6 6c 7c 39 00 40 e9 08 00 0e 00 00 b0 b1 11 31 23 28 10 b0 b1 27 08 00 04 02 00 00 00 00 04 02 00 00 00 88 88 ba 60 24 08 88 88 88 88 88 88 88 ba 71 35 18 88 88 88 88 88 00 00 00 01 00 00 00 00 00 00 00 00 00 39 00 3e ea 97 0a 82 02 13 07 00 00 00 00 00 00 80 88 ba 17 53 88 88 88 88 88 88 81 88 ba 06 42 88 88 88 88 88 88 23 10 00 02 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 39 00 23 e0 00 07 0b 27 2d 3f 3b 37 05 0a 0b 0f 11 0f 12 12 18 00 07 0b 27 2d 3f 3b 37 05 0a 0b 0f 11 0f 12 12 18 05 96 01 11 05 32 01 29"
device_reset["soysauce03"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# Soy Sauce V04
device_name["soysauce04"]="SoySauce R36S V04"
device_panel_seq["soysauce04"]="05 96 01 11 05 32 01 29"
device_reset["soysauce04"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# Clone v22
device_name["clonev22"]="Original R36S Panel 4 V22"
device_panel_seq["clonev22"]="15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 01 15 00 02 e3 00 15 00 02 25 10 15 00 02 28 6f 15 00 02 29 01 15 00 02 2a df 15 00 02 2c 22 15 00 02 c3 0f 15 00 02 37 9c 15 00 02 38 a7 15 00 02 39 41 15 00 02 80 20 15 00 02 91 67 15 00 02 92 67 15 00 02 a0 55 15 00 02 a1 50 15 00 02 a3 58 15 00 02 a4 9c 15 00 02 a7 02 15 00 02 a8 01 15 00 02 a9 21 15 00 02 aa fc 15 00 02 ab 28 15 00 02 ac 06 15 00 02 ad 06 15 00 02 ae 06 15 00 02 af 03 15 00 02 b0 08 15 00 02 b1 26 15 00 02 b2 28 15 00 02 b3 28 15 00 02 b4 03 15 00 02 b5 08 15 00 02 b6 26 15 00 02 b7 08 15 00 02 b8 26 15 00 02 2c 22 15 00 02 5c 40 15 00 02 c0 00 15 00 02 c1 00 15 00 02 c2 00 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 02 15 00 02 b0 02 15 00 02 d0 02 15 00 02 b1 0f 15 00 02 d1 10 15 00 02 b2 11 15 00 02 d2 12 15 00 02 b3 32 15 00 02 d3 33 15 00 02 b4 36 15 00 02 d4 36 15 00 02 b5 3c 15 00 02 d5 3c 15 00 02 b6 20 15 00 02 d6 20 15 00 02 b7 3e 15 00 02 d7 3e 15 00 02 b8 0e 15 00 02 d8 0d 15 00 02 b9 05 15 00 02 d9 05 15 00 02 ba 11 15 00 02 da 12 15 00 02 bb 11 15 00 02 db 11 15 00 02 bc 13 15 00 02 dc 14 15 00 02 bd 14 15 00 02 dd 14 15 00 02 be 16 15 00 02 de 18 15 00 02 bf 0e 15 00 02 df 0f 15 00 02 c0 17 15 00 02 e0 17 15 00 02 c1 07 15 00 02 e1 08 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 03 15 00 02 08 8a 15 00 02 09 8b 15 00 02 30 00 15 00 02 31 00 15 00 02 32 00 15 00 02 33 00 15 00 02 34 61 15 00 02 35 d4 15 00 02 36 24 15 00 02 37 03 15 00 02 40 86 15 00 02 41 87 15 00 02 42 84 15 00 02 43 85 15 00 02 44 11 15 00 02 45 de 15 00 02 46 dd 15 00 02 47 11 15 00 02 48 e0 15 00 02 49 df 15 00 02 50 82 15 00 02 51 83 15 00 02 52 80 15 00 02 53 81 15 00 02 54 11 15 00 02 55 e2 15 00 02 56 e1 15 00 02 57 11 15 00 02 58 e4 15 00 02 59 e3 15 00 02 82 0f 15 00 02 83 0f 15 00 02 84 00 15 00 02 85 0f 15 00 02 86 0f 15 00 02 87 0e 15 00 02 88 0e 15 00 02 89 06 15 00 02 8a 06 15 00 02 8b 07 15 00 02 8c 07 15 00 02 8d 04 15 00 02 8e 04 15 00 02 8f 05 15 00 02 90 05 15 00 02 98 0f 15 00 02 99 0f 15 00 02 9a 00 15 00 02 9b 0f 15 00 02 9c 0f 15 00 02 9d 0e 15 00 02 9e 0e 15 00 02 9f 06 15 00 02 a0 06 15 00 02 a1 07 15 00 02 a2 07 15 00 02 a3 04 15 00 02 a4 04 15 00 02 a5 05 15 00 02 a6 05 15 00 02 e0 02 15 00 02 e1 52 15 00 02 ff 30 15 00 02 ff 52 15 00 02 ff 00 15 00 02 36 02 05 c8 01 11 05 14 01 29"
device_reset["clonev22"]="&gpio3 RK_PC0 GPIO_ACTIVE_LOW"

# ========= 导出当前运行 DTB 为 DTS =========
get_running_dts() {
    local out="/tmp/running_panel.dts"

    if [ -f /sys/firmware/fdt ]; then
        dtc -I dtb -O dts /sys/firmware/fdt -o "$out" 2>/dev/null || return 1
    else
        dtc -I fs -O dts /sys/firmware/devicetree/base -o "$out" 2>/dev/null || return 1
    fi

    [ -f "$out" ] || return 1
    echo "$out"
}

# ========= 从 DTS 解析 reset-gpios，输出 &gpioX RK_PY? GPIO_ACTIVE_* =========
get_reset_gpio_string() {
    local DTS_FILE="$1"

    local LINE_RAW CELLS_STR
    local PHANDLE_RAW GPIO_NUM_RAW FLAGS_RAW
    local PHANDLE_DEC GPIO_NUM_DEC FLAGS_DEC

    LINE_RAW=$(grep "reset-gpios" "$DTS_FILE" | head -n1 || true)
    [ -z "$LINE_RAW" ] && return 1

    CELLS_STR=$(echo "$LINE_RAW" | sed -E 's/.*<([^>]+)>.*/\1/' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')
    read -r -a CELLS <<< "$CELLS_STR"

    if [ "${#CELLS[@]}" -lt 3 ]; then
        return 1
    fi

    PHANDLE_RAW="${CELLS[0]}"
    GPIO_NUM_RAW="${CELLS[1]}"
    FLAGS_RAW="${CELLS[2]}"

    PHANDLE_DEC=$((PHANDLE_RAW))
    GPIO_NUM_DEC=$((GPIO_NUM_RAW))
    FLAGS_DEC=$((FLAGS_RAW))

    # 1) phandle -> &gpioX
    local PHANDLE_LINE_NUM NODE_LINE GPIO_LABEL CONTROLLER_REF
    PHANDLE_LINE_NUM=$(grep -n "phandle[[:space:]]*=[[:space:]]*<[[:space:]]*$PHANDLE_RAW[[:space:]]*>" "$DTS_FILE" | head -n1 | cut -d: -f1 || true)
    if [ -z "$PHANDLE_LINE_NUM" ]; then
        PHANDLE_LINE_NUM=$(grep -n "phandle[[:space:]]*=[[:space:]]*<[[:space:]]*$PHANDLE_DEC[[:space:]]*>" "$DTS_FILE" | head -n1 | cut -d: -f1 || true)
    fi

    GPIO_LABEL=""
    if [ -n "$PHANDLE_LINE_NUM" ]; then
        NODE_LINE=$(sed -n "1,${PHANDLE_LINE_NUM}p" "$DTS_FILE" | tac | grep -m1 "{" || true)
        GPIO_LABEL=$(echo "$NODE_LINE" | sed -nE 's/^[[:space:]]*([A-Za-z0-9_]+):.*/\1/p')
        if [ -z "$GPIO_LABEL" ]; then
            GPIO_LABEL=$(echo "$NODE_LINE" | sed -nE 's/.*(gpio[0-9]+)@.*/\1/p')
        fi
    fi
    [ -z "$GPIO_LABEL" ] && GPIO_LABEL="gpio?"
    CONTROLLER_REF="&${GPIO_LABEL}"

    # 2) GPIO num -> RK_PAx / RK_PBx ...
    local GROUP_INDEX PIN_INDEX GROUP_LETTER GPIO_NAME
    GROUP_INDEX=$((GPIO_NUM_DEC / 8))
    PIN_INDEX=$((GPIO_NUM_DEC % 8))

    case "$GROUP_INDEX" in
      0) GROUP_LETTER="A" ;;
      1) GROUP_LETTER="B" ;;
      2) GROUP_LETTER="C" ;;
      3) GROUP_LETTER="D" ;;
      *) GROUP_LETTER="?" ;;
    esac

    GPIO_NAME="RK_P${GROUP_LETTER}${PIN_INDEX}"

    # 3) flags -> HIGH/LOW
    local FLAG_NAME
    case "$FLAGS_DEC" in
      0) FLAG_NAME="GPIO_ACTIVE_HIGH" ;;
      1) FLAG_NAME="GPIO_ACTIVE_LOW" ;;
      *) FLAG_NAME="GPIO_FLAG_${FLAGS_DEC}" ;;
    esac

    echo "${CONTROLLER_REF} ${GPIO_NAME} ${FLAG_NAME}"
    return 0
}

# ========= DetectPanel：panel-init + reset-gpio + 刷新率 =========
DetectPanel() {
    local DTS_FILE
    DTS_FILE=$(get_running_dts) || { echo "Unknown panel"; echo "Unknown"; return 1; }

    local PANEL_LINE PANEL_RAW PANEL_SEQ
    local PANEL_NAME="Unknown panel"

    # --- 1) 抽 panel-init-sequence ---
    PANEL_LINE=$(grep -n "panel-init-sequence" "$DTS_FILE" | head -n1 | cut -d: -f1 || true)
    if [ -n "$PANEL_LINE" ]; then
        PANEL_RAW=$(sed -n "${PANEL_LINE}p" "$DTS_FILE")
        PANEL_SEQ=$(echo "$PANEL_RAW" \
            | sed 's/.*\[//; s/].*//; s/[[:space:]]\+/ /g; s/^ //; s/ $//')
    fi

    # --- 2) 抽 reset-gpio 字符串 ---
    local RESET_STR
    RESET_STR=$(get_reset_gpio_string "$DTS_FILE" 2>/dev/null || true)

    # --- 3) 用设备数据库双条件匹配 ---
    if [ -n "$PANEL_SEQ" ] && [ -n "$RESET_STR" ] && [ "${#device_panel_seq[@]}" -gt 0 ]; then
        local id
        for id in "${!device_panel_seq[@]}"; do
            if [ "$PANEL_SEQ" = "${device_panel_seq[$id]}" ] &&
               [ "$RESET_STR" = "${device_reset[$id]}" ]; then
                PANEL_NAME="${device_name[$id]:-$id}"
                break
            fi
        done
    fi

    # --- 4) 计算刷新率（优先按 native-mode → phandle 找 timing） ---
    local DT_LINE START END_REL END TIMING_BLOCK
    local PANEL_RATE="Unknown"

    DT_LINE=$(grep -n "display-timings" "$DTS_FILE" | head -n1 | cut -d: -f1 || true)
    if [ -n "$DT_LINE" ]; then
        local SUB NATIVE_RAW MODE_REL BRACE_REL

        # 从 display-timings 开始往下的子串
        SUB=$(tail -n +"$DT_LINE" "$DTS_FILE")

        # 1) 取出 native-mode 的值（<> 里面那坨）
        NATIVE_RAW=$(echo "$SUB" \
            | grep -m1 "native-mode" \
            | sed -E 's/.*<([^>]+)>.*/\1/' \
            | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
            || true)

        # 2) 如果有 native-mode，就用它去找对应 phandle 节点
        if [ -n "$NATIVE_RAW" ]; then
            local PH_LINE_REL
            PH_LINE_REL=$(echo "$SUB" \
                | grep -n "phandle[[:space:]]*=[[:space:]]*< *${NATIVE_RAW} *>" \
                | head -n1 | cut -d: -f1 || true)

            if [ -n "$PH_LINE_REL" ]; then
                # 在 phandle 所在行往上回溯，找最近的 "{"
                local SEARCH_BLOCK
                SEARCH_BLOCK=$(echo "$SUB" | head -n "$PH_LINE_REL")
                BRACE_REL=$(echo "$SEARCH_BLOCK" \
                    | tac \
                    | grep -n "{" \
                    | head -n1 | cut -d: -f1 || true)

                if [ -n "$BRACE_REL" ]; then
                    START=$((DT_LINE + PH_LINE_REL - BRACE_REL))
                fi
            fi
        fi

        # 3) 如果没找到（比如 dtc 没生成 phandle 属性），退回到“第一个带 clock-frequency 的 timing”
        if [ -z "$START" ]; then
            MODE_REL=$(echo "$SUB" | grep -n "clock-frequency" | head -n1 | cut -d: -f1 || true)
            if [ -n "$MODE_REL" ]; then
                local SEARCH_BLOCK2
                SEARCH_BLOCK2=$(echo "$SUB" | head -n "$MODE_REL")
                BRACE_REL=$(echo "$SEARCH_BLOCK2" \
                    | tac \
                    | grep -n "{" \
                    | head -n1 | cut -d: -f1 || true)
                if [ -n "$BRACE_REL" ]; then
                    START=$((DT_LINE + MODE_REL - BRACE_REL))
                fi
            fi
        fi

        # 4) 抽出 timing block，算刷新率
        if [ -n "$START" ]; then
            END_REL=$(tail -n +"$START" "$DTS_FILE" \
                | grep -n "};" \
                | head -n1 | cut -d: -f1 || true)

            if [ -n "$END_REL" ]; then
                END=$((START + END_REL - 1))
                TIMING_BLOCK=$(sed -n "${START},${END}p" "$DTS_FILE")

                extract_raw() {
                    echo "$TIMING_BLOCK" \
                      | grep -m1 "$1" \
                      | sed -E 's/.*< *([^>]+) *>.*/\1/' \
                      || true
                }

                to_dec() {
                    local v="$1"
                    [ -z "$v" ] && { echo ""; return; }
                    echo $((v))
                }

                local clock_raw hactive_raw vactive_raw
                local hfp_raw hs_raw hbp_raw vfp_raw vs_raw vbp_raw

                clock_raw=$(extract_raw "clock-frequency")
                hactive_raw=$(extract_raw "hactive")
                vactive_raw=$(extract_raw "vactive")
                hfp_raw=$(extract_raw "hfront-porch")
                hs_raw=$(extract_raw "hsync-len")
                hbp_raw=$(extract_raw "hback-porch")
                vfp_raw=$(extract_raw "vfront-porch")
                vs_raw=$(extract_raw "vsync-len")
                vbp_raw=$(extract_raw "vback-porch")

                if [ -n "$clock_raw" ] && [ -n "$hactive_raw" ] && [ -n "$vactive_raw" ]; then
                    local clock hactive vactive hfp hs hbp vfp vs vbp
                    local Htotal Vtotal DENOM REFRESH_X1000 REFRESH_INT REFRESH_DEC

                    clock=$(to_dec "$clock_raw")
                    hactive=$(to_dec "$hactive_raw")
                    vactive=$(to_dec "$vactive_raw")
                    hfp=$(to_dec "${hfp_raw:-0}")
                    hs=$(to_dec "${hs_raw:-0}")
                    hbp=$(to_dec "${hbp_raw:-0}")
                    vfp=$(to_dec "${vfp_raw:-0}")
                    vs=$(to_dec "${vs_raw:-0}")
                    vbp=$(to_dec "${vbp_raw:-0}")

                    Htotal=$((hactive + hfp + hs + hbp))
                    Vtotal=$((vactive + vfp + vs + vbp))
                    DENOM=$((Htotal * Vtotal))

                    if [ "$DENOM" -gt 0 ]; then
                        REFRESH_X1000=$(( clock * 1000 / DENOM ))
                        REFRESH_INT=$((REFRESH_X1000 / 1000))
                        REFRESH_DEC=$((REFRESH_X1000 % 1000))
                        printf -v REFRESH_DEC "%03d" "$REFRESH_DEC"
                        PANEL_RATE="${REFRESH_INT}.${REFRESH_DEC}"
                    fi
                fi
            fi
        fi
    fi

    echo "$PANEL_NAME"
    echo "$PANEL_RATE"
}

# --- SD Info ---
GetSDInfo() {
    local LABEL=$1
    local MOUNTPOINT=$2

    local DEV
    DEV=$(lsblk -no pkname "$(findmnt -n -o SOURCE "$MOUNTPOINT")" 2>/dev/null | head -n1)
    if [ -z "$DEV" ]; then
        echo "  • Not inserted"
        return
    fi

    local TOTAL
    TOTAL=$(lsblk -b -dn -o SIZE "/dev/$DEV" | awk '{s+=$1} END {print s}')
    local TOTAL_GB
    TOTAL_GB=$(awk "BEGIN {printf \"%.2f\", $TOTAL/1024/1024/1024}")

    local USED=0
    local AVAIL=0
    for part in $(lsblk -ln -o NAME "/dev/$DEV"); do
        local MP
        MP=$(lsblk -ln -o MOUNTPOINT "/dev/$part")
        [[ "$MP" == "/boot" ]] && continue
        if [ -n "$MP" ]; then
            USED_PART=$(df -B1 --output=used "$MP" | tail -1)
            AVAIL_PART=$(df -B1 --output=avail "$MP" | tail -1)
            USED=$((USED + USED_PART))
            AVAIL=$((AVAIL + AVAIL_PART))
        fi
    done
    local USED_GB
    USED_GB=$(awk "BEGIN {printf \"%.2f\", $USED/1024/1024/1024}")
    local AVAIL_GB
    AVAIL_GB=$(awk "BEGIN {printf \"%.2f\", $AVAIL/1024/1024/1024}")

    echo "  • Total SD size : ${TOTAL_GB} GB"
    echo "  • Used : ${USED_GB} GB"
    echo "  • Available : ${AVAIL_GB} GB"
}

ShowInfos() {
    setfont /usr/share/consolefonts/Lat7-Terminus16.psf.gz

    local PANEL_VERSION PANEL_RATE
    local PANEL_ARR

    mapfile -t PANEL_ARR < <(DetectPanel)

    PANEL_VERSION="${PANEL_ARR[0]}"
    PANEL_RATE="${PANEL_ARR[1]}"

    [ -z "$PANEL_VERSION" ] && PANEL_VERSION="Unknown panel"
    [ -z "$PANEL_RATE" ] && PANEL_RATE="Unknown"

    local MEM_TOTAL_KB MEM_AVAILABLE_KB
    MEM_TOTAL_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    MEM_AVAILABLE_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    local MEM_TOTAL MEM_AVAILABLE MEM_USED
    MEM_TOTAL=$(awk "BEGIN {printf \"%.0f MB\", $MEM_TOTAL_KB/1024}")
    MEM_AVAILABLE=$(awk "BEGIN {printf \"%.0f MB\", $MEM_AVAILABLE_KB/1024}")
    MEM_USED=$(awk "BEGIN {printf \"%.0f MB\", ($MEM_TOTAL_KB - $MEM_AVAILABLE_KB)/1024}")

    local SD1_INFO SD2_INFO
    SD1_INFO=$(GetSDInfo "SD1" "/roms")
    SD2_INFO=$(GetSDInfo "SD2" "/roms2")

    PLYMOUTH_FILE="/usr/share/plymouth/themes/text.plymouth"
    local ARK_VERSION LINE

    if [ -f "$PLYMOUTH_FILE" ]; then
        LINE=$(grep -E '^title=' "$PLYMOUTH_FILE" | head -n1)
        LINE="${LINE#title=}"
        LINE="${LINE//\"/}"
        ARK_VERSION=$(echo "$LINE" | sed -n 's/^[^(]*(\([^)]*\)).*/\1/p')
        [ -z "$ARK_VERSION" ] && ARK_VERSION="Unknown"
    else
        ARK_VERSION="Unknown"
    fi

    dialog --backtitle "$APP_NAME" --msgbox "\
    ------------------Display---------------------
  • Detected panel : $PANEL_VERSION
  • Refresh rate   : $PANEL_RATE Hz

-------------------Memory----------------------
  • Total      : $MEM_TOTAL
  • Used       : $MEM_USED
  • Available  : $MEM_AVAILABLE

-------------------SD Card 1-------------------
$SD1_INFO

-------------------SD Card 2-------------------
$SD2_INFO

-------------------System----------------------
  • ArkOS Version : $ARK_VERSION
" 25 51 > "$CURR_TTY"
}

# --- Lancement ---
sudo chmod 666 "$CURR_TTY"
printf "\e[?25l" > "$CURR_TTY"
clear > "$CURR_TTY"
dialog --clear
trap ExitMenu EXIT

sudo chmod 666 /dev/uinput
export SDL_GAMECONTROLLERCONFIG_FILE="/opt/inttools/gamecontrollerdb.txt"
pgrep -f gptokeyb | sudo xargs kill -9 2>/dev/null
/opt/inttools/gptokeyb -1 "InfoSystem.sh" -c "/opt/inttools/keys.gptk" > /dev/null 2>&1 &

# --- Demarrage ---
ShowInfos
