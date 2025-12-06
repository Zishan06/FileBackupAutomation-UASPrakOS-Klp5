#!/bin/bash


# Load konfigurasi default
source "$(dirname "$0")/config.sh"

# Folder tujuan dibuat otomatis jika belum ada
mkdir -p "$BACKUP_DIR/logs"

cat << "EOF"
     _____       _                      _ 
    / ____|     | |                    | |
   | (___   __ _| | ___ _  _ _ __ ___  | |
    \___ \ / _`| |/ _ \ | | | '_` \| | |
    ____) | (_| | |  __/ |_| | | | | | |_|
   |_____/ \__,_|_|\___|\__,_|_| |_| |_(_)

--- SCRIPT DIMULAI ---
EOF

# Format tanggal
DATE=$(date +"%Y%m%d-%H%M%S")

# Input user
read -p "Masukkan folder sumber (source folder) yang ingin dibackup: " SOURCE_DIR
read -p "Masukkan folder tujuan (destination folder) untuk backup: " BACKUP_DIR
read -p "Masukkan jumlah hari maksimum penyimpanan backup (retention days): " RETENTION_DAYS

# Validasi input
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Direktori sumber tidak ada: $SOURCE_DIR"
    exit 1
fi

mkdir -p "$BACKUP_DIR/logs"

# Nama file backup
BACKUP_NAME="backup-$DATE.tar.gz"

# File log
LOG_FILE="$BACKUP_DIR/logs/backup.log"

# Fungsi log
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") | $1" >> "$LOG_FILE"
}

# Mulai backup
log "Backup dimulai di: $SOURCE_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" . 2>/dev/null

if [ $? -eq 0 ]; then
    # Hitung ukuran file backup
    FILESIZE_BYTES=$(stat -c %s "$BACKUP_DIR/$BACKUP_NAME" 2>/dev/null || echo "0")
    FILESIZE_MB=$(echo "scale=2; $FILESIZE_BYTES/1024/1024" | bc)

    log "Backup berhasil: $BACKUP_NAME"
    log "Ukuran backup: $FILESIZE_MB MB"
    log "Backup selesai."

    echo "Backup selesai: $BACKUP_NAME"
else
    log "Backup gagal!"
    log "Backup berhenti karena kesalahan."
    echo "Backup gagal, cek log: $LOG_FILE"
    exit 1
fi

# Rotasi backup: hapus file lebih tua dari RETENTION_DAYS
find "$BACKUP_DIR" -maxdepth 1 -type f -name "backup-*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;
log "Backup lama (> $RETENTION_DAYS hari) dihapus jika ada."

echo "--- SCRIPT SELESAI ---"
