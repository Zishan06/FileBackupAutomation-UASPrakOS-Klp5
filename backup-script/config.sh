#!/bin/bash

# Lokasi file log
LOG_FILE="..\log\backup.log"

# Direktori sumber untuk backup
SOURCE_DIR="..\sample-file"

# Direktori tujuan untuk menyimpan backup
BACKUP_DIR="..\backup-file"

# Format nama file backup
DATE_FORMAT=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="backup-$DATE_FORMAT.tar.gz"