#!/bin/bash

set -e

echo -e "\n[*] Starting full Kali APT repair and upgrade...\n"

# === 1. Restore default Kali sources.list ===
echo "[*] Restoring default /etc/apt/sources.list..."
cat <<EOF | sudo tee /etc/apt/sources.list > /dev/null
deb http://http.kali.org/kali kali-rolling main non-free-firmware contrib non-free
EOF
echo "[+] sources.list reset to default Kali rolling source"

# === 2. Fix GPG key permissions ===
GPG_FILE="/etc/apt/trusted.gpg.d/kali.gpg"
if [ -f "$GPG_FILE" ]; then
    echo "[*] Fixing GPG key permissions for: $GPG_FILE"
    sudo chmod 644 "$GPG_FILE"
    sudo chown root:root "$GPG_FILE"
    echo "[+] GPG permissions fixed"
else
    echo "[!] GPG file not found at $GPG_FILE – skipping"
fi

# === 3. Disable and remove broken cnf-update-db hook ===
echo "[*] Disabling APT cnf-update-db hook..."
echo 'APT::Update::Post-Invoke-Success "";' | sudo tee /etc/apt/apt.conf.d/99nocnf > /dev/null
if [ -f /usr/lib/cnf-update-db ]; then
    sudo rm -f /usr/lib/cnf-update-db
    echo "[+] Removed broken /usr/lib/cnf-update-db"
fi

# === 4. Ensure Kali archive keyring is installed ===
KEYRING_FILE="/usr/share/keyrings/kali-archive-keyring.gpg"
if [ ! -f "$KEYRING_FILE" ]; then
    echo "[*] Downloading latest Kali keyring..."
    sudo wget https://archive.kali.org/archive-keyring.gpg -O "$KEYRING_FILE"
    echo "[+] Installed new keyring at $KEYRING_FILE"
else
    echo "[+] Keyring already present at $KEYRING_FILE"
fi

# === 5. Run apt update ===
echo -e "\n[*] Updating APT package list..."
sudo apt update

# === 6. Auto-upgrade all packages ===
echo -e "\n[*] Performing full system upgrade..."
sudo apt full-upgrade -y

echo -e "\n[✓] Kali APT repair and full upgrade complete."
