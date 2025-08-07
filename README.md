# Kali APT Repair

A simple Bash script to repair common issues with APT in Kali Linux:

✅ Restore official Kali `sources.list`  
✅ Fix GPG key permission errors  
✅ Install updated Kali signing key  
✅ Remove broken `cnf-update-db` script  
✅ Perform full system upgrade (`apt full-upgrade`)

---

## Usage

```bash
git clone https://github.com/YOUR_USERNAME/kali-apt-repair.git
cd kali-apt-repair
chmod +x kali-apt-repair-full.sh
sudo ./kali-apt-repair-full.sh
