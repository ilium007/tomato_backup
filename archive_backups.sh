#!/bin/sh

logger -t "nvram_archive" "start script"

backup_path="/mnt/EXTUSB/backups"
backup_files=$(ls $backup_path/*.nvram)
keep_for_days=5
date_today=$(date +%s)

for file in $backup_files; do
  logger -t "nvram_archive" "$file"
  file_mod_date=$(/bin/date -r $file +%s)
  if [ $(( ( $date_today - $file_mod_date ) / 86400 )) -ge $keep_for_days ]; then
    logger -t "nvram_archive" "deleting $file"
    rm $file
  fi
done
