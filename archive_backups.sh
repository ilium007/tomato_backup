#!/bin/sh

logger -t "nvram_archive" "start script"

#keep_for_days=$1
#[ $# -eq 0 ] && { echo "Usage: $0 days_to_keep" ; logger -t "nvram_archive" "end script with error; no arg supplied"; exit 1; }
#echo "removing backups older than $keep_for_days days"

keep_for_days=${1-14}
echo "removing backups older than $keep_for_days days"
logger -t "nvram_archive" "removing backups older than $keep_for_days days"

backup_path="/mnt/EXTUSB/backups"

backup_files=$(ls $backup_path/*.nvram 2>/dev/null)

if [ ${#backup_files} -eq 0 ]; then
  echo "no backup files to archive"
  logger -t "nvram_archive" "no backup files to archive"
  logger -t "nvram_archive" "end script"
  exit 0
fi

date_today=$(date +%s)

for file in $backup_files; do
  echo "checking $file"
  logger -t "nvram_archive" "checking $file"
  file_mod_date=$(/bin/date -r $file +%s)
  if [ $(( ( $date_today - $file_mod_date ) / 86400 )) -ge $keep_for_days ]; then
    echo "deleting $file"
    logger -t "nvram_archive" "deleting $file"
    rm $file
    [ $? -gt 0 ] && { logger -t "nvram_archive" "end script with error; failed to remove file $file"; exit 1; }
  fi
done

logger -t "nvram_archive" "end script""archive_backups.sh" 17L, 427C
