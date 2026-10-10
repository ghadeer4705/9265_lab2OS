dir = dir
malicious_dir = malicious_dir
interval_secs = 5
.PHONY: all setup antivirus restore
all: setup
setup:
	mkdir -p $(malicious_dir)
antivirus: setup
	bash antivirusd.sh $(dir) $(malicious_dir) $(interval_secs)
restore: setup
	bash restore.sh $(dir) $(malicious_dir)
