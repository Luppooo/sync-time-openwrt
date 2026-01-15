#!/bin/sh
set -e
GREEN="$(printf '\033[32m')"
BLUE="$(printf '\033[34m')"
CYAN="$(printf '\033[36m')"
YELLOW="$(printf '\033[33m')"
RED="$(printf '\033[31m')"
WHITE="$(printf '\033[37m')"
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

info()  { printf "${CYAN}[INFO]${NC} %s\n" "$1"; }
ok()    { printf "${GREEN}[OK]${NC}   %s\n" "$1"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$1"; }

typehack() {
  text="$1"
  printf "${CYAN}"
  for i in $(seq 1 ${#text}); do
    printf "%s" "$(echo "$text" | cut -c$i)"
    sleep 0.03
  done
  printf "${NC}\n"
}

spinner() {
  frames="| / - \\"
  for i in $(seq 1 6); do
    for f in $frames; do
      printf "\r${CYAN}$f${NC}"
      sleep 0.1
    done
  done
  printf "\r"
}

progress() {
  total=20
  for i in $(seq 1 $total); do
    printf "\r${GREEN}["
    for j in $(seq 1 $i); do printf "█"; done
    printf "] %d%%${NC}" $((i*100/total))
    sleep 0.05
  done
  echo
}

if [ "$(id -u)" != "0" ]; then
  error "Installer harus dijalankan sebagai root!"
  exit 1
fi

clear
logo_text
printf "${WHITE} Author   : ${AUTHOR}${NC}\n"
printf "${WHITE} Version  : ${VERSION}${NC}\n"
printf "${WHITE} License  : ${LICENSE}${NC}\n"
printf "${WHITE} Repo     : ${REPO}${NC}\n"
printf "${WHITE} Copyright: © ${YEAR} ${AUTHOR}${NC}\n"
printf "${BLUE}==============================================${NC}\n\n"

info "Installer akan mengunduh script dari GitHub."

while true; do
  printf "${CYAN}Lanjutkan download? (y/n): ${NC}"
  read -r yn </dev/tty
  case "$yn" in
    y|Y) ok "Melanjutkan instalasi..."; break ;;
    n|N) warn "Instalasi dibatalkan oleh user."; exit 0 ;;
    *) warn "Input tidak valid. Gunakan y atau n." ;;
  esac
done

typehack "Mengunduh script utama..."
spinner
if wget -q -O "$TARGET" "$URL"; then
  [ ! -s "$TARGET" ] && error "File kosong setelah download!" && exit 1
  ok "Download berhasil."
else
  error "Gagal mengunduh script."
  exit 1
fi

typehack "Mengatur permission..."
spinner
chmod +x "$TARGET"
ok "Permission diset."

typehack "Menjalankan test script..."
spinner
if "$TARGET"; then
  ok "Test script berhasil dijalankan."
else
  warn "Script berjalan namun waktu mungkin belum sinkron."
fi

typehack "Mengatur cron otomatis..."
spinner

touch "$CRON_FILE"

if grep -Fq "$TARGET" "$CRON_FILE"; then
  warn "Cron sudah terpasang sebelumnya."
else
  echo "$CRON_JOB" >> "$CRON_FILE"
  ok "Cron berhasil ditambahkan tanpa menghapus cron lain."
fi

/etc/init.d/cron restart
ok "Service cron direstart."

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
