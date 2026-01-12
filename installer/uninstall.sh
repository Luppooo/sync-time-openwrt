#!/bin/sh
set -e

GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
WHITE="\033[1;37m"
NC="\033[0m"

AUTHOR="Luppooo"
VERSION="v1.0.0"

TARGET="/usr/bin/sync_time.sh"

logo_text() {
  echo "${BLUE}   ____                     _      __      __${NC}"
  echo "${BLUE}  / __ \\____  ___  _____   | | /| / /___ _/ /_${NC}"
  echo "${BLUE} / / / / __ \\/ _ \\/ ___/   | |/ |/ / __ \`/ __/${NC}"
  echo "${BLUE}/ /_/ / /_/ /  __/ /       |__/|__/ /_/ / /_  ${NC}"
  echo "${BLUE}\\____/ .___/\\___/_/                    \\__,_/\\__/ ${NC}"
  echo "${CYAN}    /_/   OpenWrt Auto Time Sync Uninstaller${NC}"
  echo "${BLUE}==============================================${NC}"
}

typehack() {
  text="$1"
  for i in $(seq 1 ${#text}); do
    printf "%s" "$(echo "$text" | cut -c$i)"
    sleep 0.03
  done
  echo
}

spinner() {
  frames="| / - \\"
  for i in $(seq 1 10); do
    for f in $frames; do
      printf "\r$f"
      sleep 0.1
    done
  done
  printf "\r"
}

progress() {
  total=20
  for i in $(seq 1 $total); do
    printf "\r["
    for j in $(seq 1 $i); do printf "█"; done
    printf "] %d%%" $((i*100/total))
    sleep 0.05
  done
  echo
}

log_info()  { echo "${BLUE}[INFO]${NC} $1"; }
log_warn()  { echo "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo "${RED}[ERROR]${NC} $1"; }
log_ok()    { echo "${GREEN}[OK]${NC} $1"; }

if [ "$(id -u)" != "0" ]; then
  log_error "Uninstaller harus dijalankan sebagai root!"
  exit 1
fi

clear
logo_text
echo "${CYAN} Author   : ${AUTHOR}${NC}"
echo "${CYAN} Version  : ${VERSION}${NC}"
echo "${BLUE}==============================================${NC}"
echo ""

printf "${YELLOW}Lanjutkan uninstall? (y/n): ${NC}"
read yn

case "$yn" in
  y|Y) echo "${GREEN}Melanjutkan uninstall...${NC}" ;;
  n|N) echo "${YELLOW}Uninstall dibatalkan.${NC}"; exit 0 ;;
  *) echo "${RED}Input tidak valid.${NC}"; exit 1 ;;
esac

typehack "Menghapus script utama..."
spinner
rm -f "$TARGET"
log_ok "Script dihapus."

typehack "Menghapus cron job..."
spinner
sed -i '/sync_time.sh/d' /etc/crontabs/root
log_ok "Cron dibersihkan."

typehack "Merestart cron service..."
spinner
/etc/init.d/cron restart
log_ok "Cron direstart."

typehack "Menyelesaikan uninstall..."
progress

echo ""
echo "${BLUE}==============================================${NC}"
echo "${GREEN} Uninstall Berhasil!${NC}"
echo "${BLUE}----------------------------------------------${NC}"
echo "${WHITE} Script  : Dihapus${NC}"
echo "${WHITE} Cron    : Dibersihkan${NC}"
echo "${BLUE}==============================================${NC}"
echo "${GREEN} Terima kasih telah menggunakan sync-time-openwrt${NC}"
echo "${BLUE}==============================================${NC}"
