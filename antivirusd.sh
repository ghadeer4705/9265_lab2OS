#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dir> <malicious_dir> <interval-secs>"
    exit 1
fi
dir="$1"
malicious_dir="$2"
interval_secs="$3"
scan_files() {
for file in "$dir"/*; do
[ -f "$file" ] || continue
filename="${file##*/}"
extension="${filename##*.}"
suspicious=false
case "$extension" in 
exe|bat|vbs|scr|ps1)
suspicious=true
;;
esac
if grep -qiE 'virus|trojan|malware|worm|ransomware' "$file"; then
suspicious=true
fi
if [ "$suspicious" = true ]; then
if cp -- "$file" "$malicious_dir/" && rm -- "$file"; then
echo "$filename is malicious and it is DELETED"
fi
fi
done
}
while true; do
ls -l "$dir" > directory-info.new
if [ ! -f directory-info.last ]; then
scan_files
ls -l "$dir" > directory-info.last
elif ! cmp -s directory-info.new directory-info.last; then
scan_files
ls -l "$dir" > directory-info.last
fi
sleep "$interval_secs"
done
