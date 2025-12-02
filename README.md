Sebuah skrip sederhana namun efisien yang ditulis dalam Bash untuk membuat arsip terkompresi dari direktori sumber (source) yang ditentukan pengguna ke lokasi tujuan (destination) yang juga ditentukan oleh pengguna. Skrip ini mencatat (logging) setiap aktivitas backup untuk pelacakan.

#Fitur Utama#
 
- Pembuatan Arsip Terkompresi: Menggunakan utilitas tar dengan kompresi gzip (tar -czf).
- Penamaan Berbasis Waktu: Nama file backup secara otomatis mencakup timestamp (backup_YYYY-MM-DD_HH-MM-SS.tar.gz) untuk mencegah penimpaan dan memudahkan pelacakan versi.
- Manajemen Direktori: Secara otomatis membuat direktori tujuan (destination) jika belum ada.Logging Aktivitas: Mencatat waktu mulai, status keberhasilan/kegagalan, dan ukuran file backup ke dalam file logfile.txt di direktori tujuan.Validasi Keberhasilan: Memeriksa kode exit dari perintah tar untuk menentukan status backup yang akurat.

#Persiapan untuk running# 
Ini memerlukan lingkungan Linux atau sistem operasi berbasis Unix (termasuk WSL di Windows atau macOS) yang telah menginstal utilitas berikut:
- Bash (Bourne Again SHell)
- tar (untuk pengarsipan dan kompresi)
- date (untuk timestamp)
- stat (untuk mendapatkan ukuran file)

#Cara Running#
1. Simpan SkripSimpan kode di atas ke dalam file, misalnya backup_script.sh.
2. Berikan Izin EksekusiJadikan skrip dapat dieksekusi menggunakan perintah '''chmod +x backup_script.sh'''
3. Jalankan SkripJalankan skrip dari terminal Anda '''./backup_script.sh'''
4. Input DirektoriSkrip akan meminta Anda untuk memasukkan dua informasi:PromptDeskripsiContoh InputMasukkan Direktori yang mau dibackup:Path absolut atau relatif ke folder yang ingin Anda arsipkan./home/user/data_pentingMasukkan Direktori tujuan:Path absolut atau relatif tempat Anda ingin menyimpan file backup (.tar.gz)./mnt/backup_drive/project_backups

#Detail Logging#
Semua kegiatan backup dicatat dalam file logfile.txt yang disimpan di dalam Direktori Tujuan yang Anda tentukan.Format log yang dicatat adalah:[TIMESTAMP] | [Pesan Status/Aksi]

Contoh isi logfile.txt:
- 2025-12-02_12-22-53 | Backup dimulai di: /home/user/data_penting
- 2025-12-02_12-22-53 | Backup berhasil di: /mnt/backup_drive/project_backups/backup_2025-12-02_12-22-53.tar.gz
- 2025-12-02_12-22-53 | Besar backup adalah 54 MB

