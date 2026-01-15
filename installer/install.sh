#!/bin/sh
set -e

# ===== COLOR (PRINTF SAFE) =====
GREEN="$(printf '\033[1;32m')"
BLUE="$(printf '\033[1;34m')"
CYAN="$(printf '\033[1;36m')"
YELLOW="$(printf '\033[1;33m')"
RED="$(printf '\033[1;31m')"
WHITE="$(printf '\033[1;37m')"
NC="$(printf '\033[0m')"

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
  printf "${BLUE}   ____                     _      __      __${NC}\n"
  printf "${BLUE}  / __ \\____  ___  _____   | | /| / /___ _/ /_${NC}\n"
  printf "${BLUE} / / / / __ \\/ _ \\/ ___/   | |/ |/ / __ \`/ __/${NC}\n"
  printf "${BLUE}/ /_/ / /_/ /  __/ /       |__/|__/ /_/ / /_  ${NC}\n"
  printf "${BLUE}\\____/ .___/\\___/_/                    \\__,_/\\__/ ${NC}\n"
  printf "${CYAN}    /_/   OpenWrt Auto Time Sync Installer${NC}\n"
  printf "${BLUE}==============================================${NC}\n"
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

log_info()  { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
log_warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
log_error() { printf "${RED}[ERROR]${NC} %s\n" "$1"; }
log_ok()    { printf "${GREEN}[OK]${NC} %s\n" "$1"; }

if [ "$(id -u)" != "0" ]; then
  log_error "Installer harus dijalankan sebagai root!"
  exit 1
fi

clear
logo_text
printf "${CYAN} Author   : ${AUTHOR}${NC}\n"
printf "${CYAN} Version  : ${VERSION}${NC}\n"
printf "${CYAN} License  : ${LICENSE}${NC}\n"
printf "${CYAN} Repo     : ${REPO}${NC}\n"
printf "${CYAN} Copyright: © ${YEAR} ${AUTHOR}${NC}\n"
printf "${BLUE}==============================================${NC}\n\n"

printf "Installer akan mengunduh script dari GitHub.\n"

while true; do
  printf "Lanjutkan download? (y/n): "
  read -r yn </dev/tty
  case "$yn" in
    y|Y) printf "Melanjutkan instalasi...\n"; break ;;
    n|N) printf "Instalasi dibatalkan oleh user.\n"; exit 0 ;;
    *) printf "Input tidak valid. Gunakan y atau n.\n" ;;
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

printf "\n"
printf "${BLUE}==============================================${NC}\n"
printf "${GREEN} Instalasi Berhasil!${NC}\n"
printf "${BLUE}----------------------------------------------${NC}\n"
printf "${WHITE} Script  : $TARGET${NC}\n"
printf "${WHITE} Cron    : Setiap 5 menit${NC}\n"
printf "${WHITE} Version : $VERSION${NC}\n"
printf "${WHITE} Repo    : $REPO${NC}\n"
printf "${BLUE}==============================================${NC}\n"
printf "${GREEN} Terima kasih telah menggunakan sync-time-openwrt${NC}\n"
printf "${BLUE}==============================================${NC}\n"
