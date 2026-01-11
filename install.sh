#!/bin/sh

GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

AUTHOR="Luppooo"
LICENSE="MIT License"
VERSION="v1.0.0"
REPO="https://github.com/Luppooo/sync-time-openwrt"
YEAR="2026"

echo "${BLUE}======================================${NC}"
echo "${GREEN}   OpenWrt Auto Time Sync Installer${NC}"
echo "${BLUE}======================================${NC}"
echo " Author   : ${AUTHOR}"
echo " Version  : ${VERSION}"
echo " License  : ${LICENSE}"
echo " Repo     : ${REPO}"
echo " Copyright: © ${YEAR} ${AUTHOR}"
echo "${BLUE}======================================${NC}"
echo ""

URL="https://raw.githubusercontent.com/Luppooo/sync-time-openwrt/main/scripts/sync_time.sh"
TARGET="/usr/bin/sync_time.sh"

echo "${YELLOW}[1/4] Mengunduh script...${NC}"
wget -q -O $TARGET $URL || {
  echo "${RED}Gagal mengunduh script!${NC}"
  exit 1
}

echo "${YELLOW}[2/4] Mengatur izin eksekusi...${NC}"
chmod +x $TARGET

echo "${YELLOW}[3/4] Menjalankan test script...${NC}"
$TARGET && echo "${GREEN}Test berhasil.${NC}"

echo "${YELLOW}[4/4] Memasang cron otomatis...${NC}"
grep -q "sync_time.sh" /etc/crontabs/root || \
echo "*/5 * * * * $TARGET >/dev/null 2>&1" >> /etc/crontabs/root

/etc/init.d/cron restart

echo ""
echo "${BLUE}======================================${NC}"
echo "${GREEN} Instalasi Selesai!${NC}"
echo "${BLUE}--------------------------------------${NC}"
echo " Script : ${TARGET}"
echo " Cron   : Setiap 5 menit"
echo " Version: ${VERSION}"
echo " Repo   : ${REPO}"
echo "${BLUE}======================================${NC}"
echo "${GREEN} Terima kasih telah menggunakan script ini${NC}"
echo "${BLUE}======================================${NC}"
