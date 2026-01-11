# ⏰ sync-time-openwrt
![OpenWrt](https://img.shields.io/badge/OpenWrt-Compatible-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)
![Shell](https://img.shields.io/badge/Shell-BusyBox-orange)

Script sinkronisasi waktu otomatis untuk OpenWrt menggunakan HTTP header sebagai alternatif saat NTP tidak tersedia.

> Cocok untuk router tanpa RTC atau ISP yang memblokir NTP.

---


## 📡 Kompatibilitas
• OpenWrt 19+
• BusyBox shell
• Router LTE / modem
• Router tanpa RTC

## 🚀 Fitur

- Sinkron waktu otomatis
- Bisa berjalan tanpa NTP
- Ringan & cepat
- Khusus OpenWrt
- Auto pasang cron
- Cocok untuk router modem / LTE

---

## ⚡ Instalasi Otomatis

```
wget -O - https://raw.githubusercontent.com/Luppooo/sync-time-openwrt/main/install.sh | sh

```
## 🔧 Instalasi Manual

```
wget https://raw.githubusercontent.com/Luppooo/sync-time-openwrt/main/sync_time.sh
chmod +x sync_time.sh
mv sync_time.sh /usr/bin/

```
## 🧪 Test Script

```
/usr/bin/sync_time.sh
date
```
## 🗑 Uninstall
```
rm -f /usr/bin/sync_time.sh
sed -i '/sync_time.sh/d' /etc/crontabs/root
/etc/init.d/cron restart
```
## 📡 Kompatibilitas
• OpenWrt 19+
• BusyBox shell
• Router LTE / modem
• Router tanpa RTC
