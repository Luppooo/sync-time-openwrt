#!/bin/sh
set -e

NEON_CYAN="$(printf '\033[96m')"
NEON_MAGENTA="$(printf '\033[95m')"
NEON_YELLOW="$(printf '\033[93m')"
NEON_RED="$(printf '\033[91m')"
NEON_BLUE="$(printf '\033[94m')"
NEON_GREEN="$(printf '\033[92m')"
NC="$(printf '\033[0m')"

AUTHOR="Luppooo"
VERSION="v1.0.0"

TARGET="/usr/bin/sync_time.sh"
CRON_FILE="/etc/crontabs/root"

logo_text() {
  printf "${NEON_MAGENTA}   ____                     _      __      __${NC}\n"
  printf "${NEON_MAGENTA}  / __ \\____  ___  _____   | | /| / /___ _/ /_${NC}\n"
  printf "${NEON_MAGENTA} / / / / __ \\/ _ \\/ ___/   | |/ |/ / __ \`/ __/${NC}\n"
  printf "${NEON_MAGENTA}/ /_/ / /_/ /  __/ /       |__/|__/ /_/ / /_  ${NC}\n"
  printf "${NEON_MAGENTA}\\____/ .___/\\___/_/                    \\__,_/\\__/ ${NC}\n"
  printf "${NEON_CYAN}    /_/   OpenWrt Auto Time Sync Uninstaller${NC}\n"
  printf "${NEON_MAGENTA}==============================================${NC}\n"
}

info()  { printf "${NEON_CYAN}[INFO] %s${NC}\n" "$1"; }
ok()    { printf "${NEON_GREEN}[OK] %s${NC}\n" "$1"; }
warn()  { printf "${NEON_YELLOW}[WARN] %s${NC}\n" "$1"; }
error() { printf "${NEON_RED}[ERROR] %s${NC}\n" "$1"; }
step()  { printf "${NEON_MAGENTA}>> %s${NC}\n" "$1"; }

spinner() {
  frames="| / - \\"
  for i in 1 2 3 4 5; do
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
    printf "\r${NEON_CYAN}["
    for j in $(seq 1 $i); do printf "█"; done
    printf "] %d%%${NC}" $((i*100/total))
    sleep 0.05
  done
  echo
}

if [ "$(id -u)" != "0" ]; then
  error "Uninstaller harus dijalankan sebagai root!"
  exit 1
fi

clear
logo_text
printf "${NEON_BLUE} Author   : ${AUTHOR}${NC}\n"
printf "${NEON_BLUE} Version  : ${VERSION}${NC}\n"
printf "${NEON_MAGENTA}==============================================${NC}\n\n"

while true; do
  printf "${NEON_CYAN}Lanjutkan uninstall? (y/n): ${NC}"
  read -r yn </dev/tty
  case "$yn" in
    y|Y) ok "Melanjutkan uninstall..."; break ;;
    n|N) warn "Uninstall dibatalkan."; exit 0 ;;
    *) warn "Input tidak valid. Gunakan y atau n." ;;
  esac
done

step "Menghapus script utama..."
spinner
rm -f "$TARGET"
ok "Script dihapus."

step "Membersihkan cron job..."
spinner
sed -i '/sync_time.sh/d' "$CRON_FILE" 2>/dev/null || true
ok "Cron dibersihkan."

step "Merestart cron service..."
spinner
/etc/init.d/cron restart
ok "Cron direstart."

step "Menyelesaikan uninstall..."
progress

printf "\n"
printf "${NEON_MAGENTA}==============================================${NC}\n"
printf "${NEON_GREEN} Uninstall Berhasil!${NC}\n"
printf "${NEON_MAGENTA}----------------------------------------------${NC}\n"
printf "${NEON_BLUE} Script  : Dihapus${NC}\n"
printf "${NEON_BLUE} Cron    : Dibersihkan${NC}\n"
printf "${NEON_MAGENTA}==============================================${NC}\n"
printf "${NEON_CYAN} Terima kasih telah menggunakan sync-time-openwrt${NC}\n"
printf "${NEON_MAGENTA}==============================================${NC}\n"
