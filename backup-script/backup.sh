#!/bin/bash

cat << EOF
     _____       _                      _ 
    / ____|     | |                    | |
   | (___   __ _| | ___ _  _ _ __ ___  | |
    \___ \ / _\`| |/ _ \ | | | '_\` \| | |
    ____) | (_| | |  __/ |_| | | | | | |_|
   |_____/ \__,_|_|\___|\__,_|_| |_| |_(_)

--- SCRIPT DIMULAI ---
EOF

# File LOG
LOG_FILE="logfile.txt"

# Format penanggalan
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Nama backup
BACKUP_NAME="backup_$DATE.tar.gz"

# Direktori yg mau dibackup
echo "Masukkan Direktori yang mau dibackup: "
read SOURCE_DIR

# Direktori tujuan
echo "Masukkan Direktori tujuan: "
read BACKUP_DIR

# Buat folder tujuan jika tidak ada
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Update log file path
LOG_FILE="$BACKUP_DIR/logfile.txt"

echo "$DATE | Backup dimulai di: $SOURCE_DIR" >> "$LOG_FILE"

# Backup - FIX: urutan parameter yang benar
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" . 2>/dev/null

# Cek apakah berhasil
if [ $? -eq 0 ]; then
    echo "Backup berhasil disimpan di $BACKUP_DIR/$BACKUP_NAME"
    echo "$DATE | Backup berhasil di: $BACKUP_DIR/$BACKUP_NAME" >> "$LOG_FILE"
    
    # Log ukuran backup, hitung file backupr
    if [ -f "$BACKUP_DIR/$BACKUP_NAME" ]; then
        FILESIZE_BYTES=$(stat -c %s "$BACKUP_DIR/$BACKUP_NAME" 2>/dev/null || echo "0")
        FILESIZE_MB=$((FILESIZE_BYTES / 1024 / 1024))
        echo "$DATE | Besar backup adalah $FILESIZE_MB MB" >> "$LOG_FILE"
    fi
else
    echo "Gagal backup, ada kesalahan kayaknya"
    echo "$DATE | Backup gagal cik!" >> "$LOG_FILE"
    exit 1
fi

echo "--- SCRIPT SELESAI ---"


