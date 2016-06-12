# tomato_backup
Script taken from http://www.linksysinfo.org/index.php?threads/nvram-export-can-not-handle-wrap-text.68478/

backup.sh takes up to 3 optional arguments:\n
$1 - backup filename prefix; script appends the date and .nvram\n
$2 - config dir; location for the .ini file\n
$3 - backup path

archive_backups.sh takes a single optional arguement:\n
$1 - retention days for backups; defaults to 14
