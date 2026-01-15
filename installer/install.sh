#!/bin/sh
set -e
NEON_GREEN="$(printf '\033[92m')"
NEON_CYAN="$(printf '\033[96m')"
NEON_MAGENTA="$(printf '\033[95m')"
NEON_YELLOW="$(printf '\033[93m')"
NEON_RED="$(printf '\033[91m')"
NEON_BLUE="$(printf '\033[94m')"
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

# ===== UI =====
logo_text() {
  printf "${NEON_MAGENTA}   ____                     _      __      __${NC}\n"
  printf "${NEON_MAGENTA}  / __ \\____  ___  _____   | | /| / /___ _/ /_${NC}\n"
  printf "${NEON_MAGENTA} / / / / __ \\/ _ \\/ ___/   | |/ |/ / __ \`/ __/${NC}\n"
  printf "${NEON_MAGENTA}/ /_/ / /_/ /  __/ /       |__/|__/ /_/ / /_  ${NC}\n"
  printf "${NEON_MAGENTA}\\____/ .___/\\___/_/                    \\__,_/\\__/ ${NC}\n"
  printf "${NEON_CYAN}    /_/   OpenWrt Auto Time Sync Installer${NC}\n"
  printf "${NEON_MAGENTA}==============================================${NC}\n"
}

info()  { printf "${NEON_CYAN}[INFO]${NC} %s\n" "$1"; }
step()  { printf "${NEON_MAGENTA}>> ${NC}%s\n" "$1"; }
ok()    { printf "${NEON_GREEN}[OK]${NC}   %s\n" "$1"; }
warn()  { printf "${NEON_YELLOW}[WARN]${NC} %s\n" "$1"; }
error() { printf "${NEON_RED}[ERROR]${NC} %s\n" "$1"; }

typehack() {
  text="$1"
  printf "${NEON_CYAN}"
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
      printf "\r${NEON_CYAN}$f${NC}"
      sleep 0.1
    done
  done
  printf "\r"
}

progress() {
  total=20
  for i in $(seq 1 $total); do
    printf "\r${NEON_GREEN}["
    for j in $(seq 1 $i); do printf "█"; done
    printf "] %d%%${NC}" $((i*100/total))
    sleep 0.05
  done
  echo
}

# ===== CHECK ROOT =====
if [ "$(id -u)" != "0" ]; then
  error "Installer harus dijalankan sebagai root!"
  exit 1
fi

clear
logo_text
printf "${NEON_BLUE} Author   : ${AUTHOR}${NC}\n"
printf "${NEON_BLUE} Version  : ${VERSION}${NC}\n"
printf "${NEON_BLUE} License  : ${LICENSE}${NC}\n"
printf "${NEON_BLUE} Repo     : ${REPO}${NC}\n"
printf "${NEON_BLUE} Copyright: © ${YEAR} ${AUTHOR}${NC}\n"
printf "${NEON_MAGENTA}==============================================${NC}\n\n"

info "Installer akan mengunduh script dari GitHub."

while true; do
  printf "${NEON_CYAN}Lanjutkan download? (y/n): ${NC}"
  read -r yn </dev/tty
  case "$yn" in
    y|Y) ok "Melanjutkan instalasi..."; break ;;
    n|N) warn "Instalasi dibatalkan oleh user."; exit 0 ;;
    *) warn "Input tidak valid. Gunakan y atau n." ;;
  esac
done

step "Mengunduh script utama..."
spinner
if wget -q -O "$TARGET" "$URL"; then
  [ ! -s "$TARGET" ] && error "File kosong setelah download!" && exit 1
  ok "Download berhasil."
else
  error "Gagal mengunduh script."
  exit 1
fi

step "Mengatur permission..."
spinner
chmod +x "$TARGET"
ok "Permission diset."

step "Menjalankan test script..."
spinner
if "$TARGET" | while read line; do printf "${NEON_CYAN}%s${NC}\n" "$line"; done; then
  ok "Test script berhasil dijalankan."
else
  warn "Script berjalan namun waktu mungkin belum sinkron."
fi

step "Mengatur cron otomatis..."
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

step "Menyelesaikan instalasi..."
progress

printf "\n"
printf "${NEON_MAGENTA}==============================================${NC}\n"
printf "${NEON_GREEN} Instalasi Berhasil!${NC}\n"
printf "${NEON_MAGENTA}----------------------------------------------${NC}\n"
printf "${NEON_BLUE} Script  : $TARGET${NC}\n"
printf "${NEON_BLUE} Cron    : Setiap 5 menit${NC}\n"
printf "${NEON_BLUE} Version : $VERSION${NC}\n"
printf "${NEON_BLUE} Repo    : $REPO${NC}\n"
printf "${NEON_MAGENTA}==============================================${NC}\n"
printf "${NEON_GREEN} Terima kasih telah menggunakan sync-time-openwrt${NC}\n"
printf "${NEON_MAGENTA}==============================================${NC}\n"
