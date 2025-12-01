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

=

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

tar -cz "$BACKUP_DIR/$BACKUP_NAME" $SOURCE_DIR

#Cek apakah berhasil
if [ $? -eq 0 ]; then
	echo "Backup berhasil disimpan di $BACKUP_DIR/BACKUP_NAME"
else
	echo "Gagal backup, ada kesalahan kayaknya"
	exit 1
fi
