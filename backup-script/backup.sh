#!/bin/bash

source config.sh

cat << EOF
     _____       _                      _ 
    / ____|     | |                    | |
   | (___   __ _| | ___ _  _ _ __ ___  | |
    \___ \ / _\`| |/ _ \ | | | '_\` \| | |
    ____) | (_| | |  __/ |_| | | | | | |_|
   |_____/ \__,_|_|\___|\__,_|_| |_| |_(_)

--- SCRIPT DIMULAI ---
EOF

# Format penanggalan
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Direktori yg mau dibackup
echo "Masukkan Direktori yang mau dibackup: "
read SOURCE_DIR

# Direktori tujuan
echo "Masukkan Direktori tujuan: "
read BACKUP_DIR

# Lama Hari penyimpanan backup
echo "Masukkan lama penyimpanan backup (dalam hari): "
read RETENTION_DAYS

# Cek apakah folder sumber ada
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Folder sumber '$SOURCE_DIR' tidak ditemukan!"
    exit 1
fi

# Buat folder tujuan jika tidak ada
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Update log file path
echo "$DATE | Backup dimulai di: $SOURCE_DIR" >> "$LOG_FILE"

# Backup
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" . 2>/dev/null

# Cek apakah berhasil
if [ $? -eq 0 ]; then
    TIMESTAMP_END=$(date +%Y-%m-%d_%H-%M-%S)

    echo "Backup berhasil disimpan di $BACKUP_DIR/$BACKUP_NAME"
    echo "$TIMESTAMP_END | Backup berhasil di: $BACKUP_DIR/$BACKUP_NAME" >> "$LOG_FILE" 
    
    # Log ukuran backup, hitung file backupr
    if [ -f "$BACKUP_DIR/$BACKUP_NAME" ]; then
        FILESIZE_BYTES=$(stat -c %s "$BACKUP_DIR/$BACKUP_NAME" 2>/dev/null || echo "0")
        FILESIZE_MB=$((FILESIZE_BYTES / 1024 / 1024))
        echo "$DATE | Besar backup adalah $FILESIZE_MB MB | Status: SUCCESS" >> "$LOG_FILE"
    fi
else
    echo "Gagal backup, ada kesalahan kayaknya"
    echo "$DATE | Backup gagal cik! | Status: FAILED" >> "$LOG_FILE"
    exit 1
fi

if [ -n "$RETENTION_DAYS" ] && [ "$RETENTION_DAYS" -gt 0 ]; then
    echo "Memeriksa rotasi backup (> $RETENTION_DAYS hari)..."
    
    # Perintah find untuk mencari dan menghapus
    find "$BACKUP_DIR" -name "backup-*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm {} \;
    
    echo "Backup lebih dari $RETENTION_DAYS hari dihapus (rotasi backup)"
fi

echo "--- SCRIPT SELESAI ---"


