Simple Antivirus:
1- Project Overview
This project implements a simple antivirus system using bash script on ubuntu linux. It scans files in a specified directory and
detects potentially malicious files based on their file extensions or contents. Detected files are moved to a quarantine directory,
where users can choos to restore them or permanently delete them.
folder hierarchy:
9265_lab2/
├── antivirusd.sh
├── restore.sh
├── Makefile
├── README.md
├── dir/
├── malicious_dir/
├── directory-info.new
└── directory-info.last
File descriptions:
-antivirusd.sh: periodically scans the input directory and moves suspicious files to the quarantine directory.
-restore.sh: lists quarantined files and allows users to restore or permanently delete them.
-Makefile: provides commands to set up the quarantine directory and run the antivirus and restore scripts.
-README.md: explains the project, installation and usage.
-dir/: contains the files to be scanned.
-malicious_dir/: stores files detected as suspicious.
-directory-info.new: stores a snapshot of the input directory.
-directory-info.last: stores the previous snapshot used to detect changes.
The 2 snapshot files are generated during execution.
2- Prerequisites and Installation:
2.1-prerequisites:
ubuntu linux os, bash shell, linux utilities like (grep,ls,cmp,cp,mv,rm & sleep)
2.2-Installation :
update package lists: sudo apt update
install GNU make if is not already installed: sudo apt install make
check the installed versions: bash --version and make -- version
navigate to the project directory: cd ~/9265_lab2
make the scripts executable if you want to directly run them: chmod +x antivirusd.sh restore.sh
3- how to run the tools:
3.1- prepare the directories:
create the input and quarantine directories if they do not already exist: mkdir -p dir malicious_dir
place the files you want to scan inside dir/.
3.2- run the antivirus:
Run the antivirus daemon with three arguments: the input directory, the quarantine directory, and the scan interval in seconds:
bash antivirusd.sh dir malicious_dir 5
In this example, the antivirus checks the directory every five seconds.
Files that match either the extension rule or the keyword rule are moved to malicious_dir/.
The antivirus daemon keeps running until it is stopped with Ctrl+C.
3.3- run the restore tool:
open a seperate terminal, navigate to the project directory,and run: bash restore.sh dir malicious_dir
the script displays a numbered list of quarantined files. enter a file number to select a file, then choose one of the following options:
1-Restore the file to dir/.
2-Permanently delete the file from malicious_dir/.
3-Go back to the file list.
If no quarantined files are available, the script displays a message and exits.
4- Run the tools using make:
the makefile provides the following targets:
 make setup :creates malicious_dir/ if not existed
 make antivirus: starts the antivus daemon using the arguments defined in the makefile
 make restore: starts the restore tool using the arguments defined in the makefile.
the defualt scan interval and directory names are defined in the makefile.
4- Flagged extensions and keywords:
The detection rules are defined inside the scan_files() function in antivirusd.sh
4.1: flagged extensions: the final extension of each filename is extracted using:
extension="${filename##*.}"
The flagged extensions are defined in the case statement:
exe|bat|vbs|scr|ps1
only the final extension is checked for example:
-file.txt.scr: flagged because its final extension is scr
-file.scr.txt : not flagged as scr is not the final extension
-file.exec: not flagged as it is not in the flagged extensions list
4.2: flagged keywords: the flagged keywords are defined in this command:
grep -qiE 'virus|trojan|malware|worm|ransomware' "$file"
these keywords in the search are case insensitive , and a keyword can match anywhere in the file's contents, including inside
a longer word. for example: both worm and wormhole are detected.
a file is considered suspicious if it matches either the extension or the keyword rule.
