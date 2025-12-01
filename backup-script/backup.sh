#!/bin/bash

#Direktori yg mau dibackup
SOURCE_DIR="$HOME/backup-script/sample-data"

#Direktori tujuan
BACKUP_DIR="$HOME/backup-script/backups"

#Format penanggalan
DATE=$(date +%Y-%m-%d_%H-%M-%S)

#Retention days (terserah berapa)
RETENTION_DAYS=7

#Nama backup
BACKUP_NAME="backup_$DATE.tar.gz"

echo "Memulai backup direktori $SOURCE_DIR"
mkdir -p "BACKUP_DIR"
tar -cz "$BACKUP_DIR/$BACKUP_NAME" $SOURCE_DIR

#Cek apakah berhasil
if [ $? -eq 0 ]; then
	echo "Backup berhasil disimpan di $BACKUP_DIR/BACKUP_NAME"
else
	echo "Gagal backup, ada kesalahan kayaknya"
	exit 1
fi
