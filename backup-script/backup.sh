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

#Format penanggalan
DATE=$(date +%Y-%m-%d_%H-%M-%S)

#Nama backup
BACKUP_NAME="backup_$DATE.tar.gz"

#Direktori yg mau dibackup
echo "Masukkan Direktori yang mau dibackup: "
read SOURCE_DIR
#Direktori tujuan
echo "Masukkan Direktori tujuan: "
read BACKUP_DIR

tar -czf "$BACKUP_DIR/$BACKUP_NAME" $SOURCE_DIR
echo "$DATE | Backup dimulai di: $SOURCE_DIR" >> $LOG_FILE

#Cek apakah berhasil
if [ $? -eq 0 ]; then
	echo "Backup berhasil disimpan di $BACKUP_DIR/BACKUP_NAME"
	echo "$DATE | Backup berhasil di: $BACKUP_DIR" >> $LOG_FILE
else
	echo "Gagal backup, ada kesalahan kayaknya"
	echo "$DATE | Backup gagal cik!" >> $LOG_FILE
	exit 1
fi

#Log ukuran backup
FILESIZE_BYTES=$(stat -c %s "$BACKUP_DIR/$BACKUP_NAME")
FILESIZE_MB=$((FILESIZE_BYTES/1024/1024))
echo "$DATE | Besar backup adalah $FILESIZE_MB" >> $LOG_FILE


