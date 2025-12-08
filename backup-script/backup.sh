#!/bin/bash

source config.sh

# Warna output
BOLD=$'\e[1m'
RED=$'\e[0;31m'
NC=$'\e[0m' #Reset Warna

GARIS=$'\n==============================================\n'

cat << EOF 
${BOLD}
  _____       _                        _ 
 / ____|     | |                      | |
| (___   __ _| | ___ _  _ _ __ ___    | |
 \___ \ / _\ | |/ _ \ | | |  _   _ \  | |
 ____) | (_| | |  __/ |_| | | | | | | |_|
|_____/ \__,_|_|\___|\__,_|_| |_| |_| (_)  

${NC}${GARIS}
${BOLD}    Sistem Backup Otomatis By Kelompok 5${NC}
${GARIS}
EOF

# Format penanggalan
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Direktori yg mau dibackup
echo -n "${BOLD}Masukkan Direktori yang mau dibackup         : ${NC}"
read SOURCE_DIR

# Direktori tujuan
echo -n "${BOLD}Masukkan Direktori tujuan                    : ${NC}"
read BACKUP_DIR

# Lama Hari penyimpanan backup
echo -n "${BOLD}Masukkan lama penyimpanan backup (hari)      : ${NC}"
read RETENTION_DAYS

echo "${GARIS}"

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

echo -n "${BOLD}Memulai backup${NC}"

# Backup
tar --checkpoint=1000 --checkpoint-action=dot -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" . 2>/dev/null

# Cek apakah berhasil
if [ $? -eq 0 ]; then
    TIMESTAMP_END=$(date +%Y-%m-%d_%H-%M-%S)

    echo ""
    echo ""
    echo "Backup berhasil disimpan di: $BACKUP_DIR/$BACKUP_NAME"
    echo "$TIMESTAMP_END | Backup berhasil di: $BACKUP_DIR/$BACKUP_NAME" >> "$LOG_FILE" 
    
    # Log ukuran backup, hitung file backup
    if [ -f "$BACKUP_DIR/$BACKUP_NAME" ]; then
        FILESIZE_BYTES=$(stat -c %s "$BACKUP_DIR/$BACKUP_NAME" 2>/dev/null || echo "0")
        FILESIZE_MB=$((FILESIZE_BYTES / 1024 / 1024))
        echo "$TIMESTAMP_END | Besar backup adalah $FILESIZE_MB MB | Status: SUCCESS" >> "$LOG_FILE"
    fi
else
    echo ""
    echo "${RED}Gagal backup, ada kesalahan kayaknya${NC}"
    echo "$DATE | Backup gagal cik! | Status: FAILED" >> "$LOG_FILE"
    exit 1
fi

# Memeriksa rotasi backup
if [ -n "$RETENTION_DAYS" ] && [ $(awk "BEGIN {print ($RETENTION_DAYS > 0)}") -eq 1 ]; then
    echo "${GARIS}"
    echo "${BOLD}Memeriksa rotasi backup ( > $RETENTION_DAYS hari)${NC}..."
    
    OLD_BACKUPS=$(find "$BACKUP_DIR" -name "backup-*.tar.gz" -type f -mmin +$(awk "BEGIN {print int($RETENTION_DAYS * 1440)}"))
    
    if [ -n "$OLD_BACKUPS" ]; then
        echo ""
        echo "Backup lama ditemukan, menghapus file..."

        echo "$OLD_BACKUPS" | while read file; do
            echo -e "${RED}${file}${NC}"
            rm "$file"
        done

    else
        echo ""
        echo "Tidak ada backup lama yang perlu dihapus."
        exit 0
    fi
    
    echo ""
    echo "Backup lebih dari $RETENTION_DAYS hari dihapus (rotasi backup)"
fi
