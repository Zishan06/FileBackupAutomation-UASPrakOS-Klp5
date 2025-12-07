#!/bin/bash

# Lokasi file log
LOG_FILE="..\log\backup.log"

# Format nama file backup
DATE_FORMAT=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="backup-$DATE_FORMAT.tar.gz"