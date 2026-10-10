#!/bin/bash
if [ "$#" -ne 2 ]; then
echo "Usage: $0 <dir> <malicious_dir>"
exit 1
fi
dir="$1"
malicious_dir="$2"
while true; do
files=("$malicious_dir"/*)
if [ ! -f "${files[0]}" ]; then
echo "No malicious files to review."
exit 0
fi
echo "Malicious files:"
for i in "${!files[@]}"; do
echo "$((i + 1)): ${files[$i]}"
done

read -r -p "Choose a file number: " choice
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]; then
echo "Invalid choice."
continue
fi
file="${files[$((choice - 1))]}"
filename="${file##*/}"
echo ""
echo "1-Restore file"
echo "2- Permanently delete file" 
echo "3- Go back"
read -r -p "Choose an option:" option

case "$option" in
1)
if mv -- "$file" "$dir/"; then
echo  "Restored $filename to $dir."
fi
;;
2)
if rm -- "$file"; then
echo "$filename permanently deleted."
fi
;;
3)
continue
;;
*)
echo "Invalid Choice."
;;
esac
done
