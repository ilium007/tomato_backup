#!/bin/sh

#USE AT YOUR OWN RISK.
#THIS SCRIPT DOES NOT COME WITH ANY WARRANTY WHATSOEVER.
#
#Backs up selected nvram variables in "nvram export --set" format.
#
#Correctly handles multi-line entries.
#
#Thanks to ryzhov_al for basic approach.
#
#Should work equally well with both MIPS and ARM builds.
#
#Looks for a list of items to export in $etc/scriptname.ini
#OR enter items to grep for below.
#
#The items list is a list of regular expressions to match against the
#nvram variable names.
#
#Script assumes all entries are at beginning of line(prefixed with ^).
#
#Leave items list blank to backup up all of nvram.  Resulting in essentially
#the same output as MIPS "nvram export --set"
#
#The items list below is only intended as example and is not complete or
#comprehensive. Customize for your own use.
#

#Edit list below if not using .ini file, it is ignored if .ini file is found
items='
  dhcpd_
  dns_
  wl[0-9]_security_mode
  wl[0-9]_ssid
  wl[0-9]_wpa_psk
'

base=${0##*/}; base=${base%.*}
config=./$base.ini

#file to output - default to stdout
if [ "$1" != "" ] ; then
  backupfile="$1"
else
  backupfile=/proc/$$/fd/1
fi

grepstr=$( { [ -r $config ] && cat $config || echo "$items" ; } | sed -e 's/[\t ]//g;/^$/d' | sed ':a;N;$!ba;s/\n/\\\|\^/g')

{
echo "#Exporting $grepstr"
for item in $(nvram show 2>/dev/null | grep "^.*=" | grep "$grepstr"  | awk -F= "{print \$1}" | sort -u)
do
  item_value="$(nvram get $item | sed 's!\([\$\"\`]\)!\\\1!g'; echo nvgetwasnull)"
  case $item_value in
  nvgetwasnull) ;;
  *) echo "nvram set ${item}=\"${item_value%
nvgetwasnull}\"" ;;
  esac
done
}>"$backupfile"
