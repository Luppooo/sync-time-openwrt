#!/bin/sh

echo "=== OpenWrt Time Sync Installer ==="

URL="https://raw.githubusercontent.com/Luppooo/sync-time-openwrt/main/scripts/sync_time.sh"
TARGET="/usr/bin/sync_time.sh"

echo "[1/4] Download script..."
wget -q -O $TARGET $URL || exit 1

echo "[2/4] Set permission..."
chmod +x $TARGET

echo "[3/4] Test script..."
$TARGET

echo "[4/4] Install cron job..."
grep -q "sync_time.sh" /etc/crontabs/root || \
echo "*/5 * * * * $TARGET >/dev/null 2>&1" >> /etc/crontabs/root

/etc/init.d/cron restart

echo "================================="
echo "Install selesai!"
echo "Script: $TARGET"
echo "Cron: tiap 5 menit"
echo "================================="
