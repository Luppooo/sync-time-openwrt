# ⏰ sync-time-openwrt

![OpenWrt](https://img.shields.io/badge/OpenWrt-Compatible-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)
![Shell](https://img.shields.io/badge/Shell-BusyBox-orange)
![Status](https://img.shields.io/badge/Status-Stable-success)
![Version](https://img.shields.io/badge/Version-v1.0.0-blueviolet)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen)
![Made with Love](https://img.shields.io/badge/Made%20with-%E2%9D%A4-red)
![Open Source](https://img.shields.io/badge/Open%20Source-Yes-green)

Script sinkronisasi waktu otomatis untuk OpenWrt menggunakan HTTP header sebagai alternatif saat NTP tidak tersedia.

> Cocok untuk router tanpa RTC atau ISP yang memblokir NTP.

---

## ❓ Kenapa Butuh Script Ini?

Banyak router OpenWrt tidak memiliki RTC (Real Time Clock).  
Akibatnya, setiap kali router restart atau listrik mati, waktu sistem akan kembali ke waktu yang salah.

Hal ini bisa menyebabkan:

- HTTPS error
- Sertifikat dianggap kadaluarsa
- Cron job tidak berjalan
- Log sistem tidak akurat
- Update paket gagal

Script ini dibuat untuk mengatasi masalah tersebut dengan cara yang ringan, cepat, dan tanpa ketergantungan NTP.

---

## ⚙ Cara Kerja

1. Script mengirim request HTTP ke server publik.
2. Server mengirim waktu aktual melalui HTTP header.
3. Script membaca header `Date`.
4. Waktu dikonversi ke format sistem OpenWrt.
5. Sistem waktu OpenWrt diperbarui otomatis.

Semua proses ini berjalan cepat dan tidak membutuhkan NTP server.

---

## 📡 Kompatibilitas

- OpenWrt 19+
- BusyBox shell
- Router LTE / modem
- Router tanpa RTC

---

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
wget https://raw.githubusercontent.com/Luppooo/sync-time-openwrt/main/scripts/sync_time.sh
chmod +x sync_time.sh
mv sync_time.sh /usr/bin/
```
## 🕒 Jadwal Cron Default
```
*/5 * * * * /usr/bin/sync_time.sh >/dev/null 2>&1
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
## 🔐 Keamanan & Lisensi

Project ini menggunakan MIT License.
Script boleh digunakan, dimodifikasi, dan didistribusikan, dengan tetap menyertakan credit pembuat.

## 👤 Pembuat

Luppooo

GitHub:
👉 https://github.com/Luppooo

## ⭐ Dukungan

Jika project ini membantu, silakan beri ⭐ di GitHub agar bisa terus dikembangkan.
