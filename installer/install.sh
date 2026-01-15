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
LICENSE="MIT License"
VERSION="v1.0.0"
REPO="https://github.com/Luppooo/sync-time-openwrt"
YEAR="2026"

URL="https://raw.githubusercontent.com/Luppooo/sync-time-openwrt/main/scripts/sync_time.sh"
TARGET="/usr/bin/sync_time.sh"
CRON_JOB="*/5 * * * * $TARGET >/dev/null 2>&1"
CRON_FILE="/etc/crontabs/root"

logo_text() {
  echo "${BLUE}   ____                     _      __      __${NC}"
  echo "${BLUE}  / __ \\____  ___  _____   | | /| / /___ _/ /_${NC}"
  echo "${BLUE} / / / / __ \\/ _ \\/ ___/   | |/ |/ / __ \`/ __/${NC}"
  echo "${BLUE}/ /_/ / /_/ /  __/ /       |__/|__/ /_/ / /_  ${NC}"
  echo "${BLUE}\\____/ .___/\\___/_/                    \\__,_/\\__/ ${NC}"
  echo "${CYAN}    /_/   OpenWrt Auto Time Sync Installer${NC}"
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
  for i in $(seq 1 8); do
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
  log_error "Installer harus dijalankan sebagai root!"
  exit 1
fi

clear
logo_text
echo "${CYAN} Author   : ${AUTHOR}${NC}"
echo "${CYAN} Version  : ${VERSION}${NC}"
echo "${CYAN} License  : ${LICENSE}${NC}"
echo "${CYAN} Repo     : ${REPO}${NC}"
echo "${CYAN} Copyright: © ${YEAR} ${AUTHOR}${NC}"
echo "${BLUE}==============================================${NC}"
echo ""

echo "Installer akan mengunduh script dari GitHub."

while true; do
  printf "Lanjutkan download? (y/n): "
  read -r yn </dev/tty
  case "$yn" in
    y|Y) echo "Melanjutkan instalasi..."; break ;;
    n|N) echo "Instalasi dibatalkan oleh user."; exit 0 ;;
    *) echo "Input tidak valid. Gunakan y atau n." ;;
  esac
done

typehack "Mengunduh script utama..."
spinner
if wget -q -O "$TARGET" "$URL"; then
  [ ! -s "$TARGET" ] && log_error "File kosong setelah download!" && exit 1
  log_ok "Download berhasil."
else
  log_error "Gagal mengunduh script."
  exit 1
fi

typehack "Mengatur permission..."
spinner
chmod +x "$TARGET"
log_ok "Permission diset."

typehack "Menjalankan test script..."
spinner
if "$TARGET"; then
  log_ok "Test script berhasil dijalankan."
else
  log_warn "Script berjalan namun waktu mungkin belum sinkron."
fi

typehack "Mengatur cron otomatis..."
spinner

touch "$CRON_FILE"

if grep -Fq "$TARGET" "$CRON_FILE"; then
  log_warn "Cron sudah terpasang sebelumnya."
else
  echo "$CRON_JOB" >> "$CRON_FILE"
  log_ok "Cron berhasil ditambahkan tanpa menghapus cron lain."
fi

/etc/init.d/cron restart
log_ok "Service cron direstart."

typehack "Menyelesaikan instalasi..."
progress

echo ""
echo "${BLUE}==============================================${NC}"
echo "${GREEN} Instalasi Berhasil!${NC}"
echo "${BLUE}----------------------------------------------${NC}"
echo "${WHITE} Script  : $TARGET${NC}"
echo "${WHITE} Cron    : Setiap 5 menit${NC}"
echo "${WHITE} Version : $VERSION${NC}"
echo "${WHITE} Repo    : $REPO${NC}"
echo "${BLUE}==============================================${NC}"
echo "${GREEN} Terima kasih telah menggunakan sync-time-openwrt${NC}"
echo "${BLUE}==============================================${NC}"
