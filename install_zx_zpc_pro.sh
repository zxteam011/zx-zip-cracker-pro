#!/bin/bash

# Colors for output - Using true blood red (#FF0000)
BLOOD_RED='\033[38;2;255;0;0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display the banner
echo -e "${BLOOD_RED}"
cat << "EOF"
☠️  ________   __  _______         _____                                    _        _  _    ☠️
☠️ |___  /\ \ / / |___  (_)       |  __ \                                  | |      | || |   ☠️  
☠️    / /  \ V /     / / _ _ __   | |__) |_ _ ___ ___    ___ _ __ __ _  ___| | _____| || |_  ☠️
☠️   / /    > <     / / | | '_ \  |  ___/ _` / __/ __|  / __| '__/ _` |/ __| |/ / _ \__   _| ☠️
☠️  / /__  / . \   / /__| | |_) | | |  | (_| \__ \__ \ | (__| | | (_| | (__|   <  __/  | |   ☠️
☠️ /_____|/_/ \_\ /_____|_| .__/  |_|   \__,_|___/___/  \___|_|  \__,_|\___|_|\_\___|  |_|   ☠️
☠️                        | |                                                                ☠️
☠️                        |_|                                                                ☠️
EOF
echo -e "${NC}"
echo -e "${BLOOD_RED}☠️ ZX Zip Pass Cracker PRO ☠️ - Only for Educational Purpose ☠️${NC}"
echo -e "${BLOOD_RED}===============================================================${NC}"

# Function to log messages
log() {
    echo -e "${BLOOD_RED}[$(date '+%H:%M:%S')]${NC} $1"
}

# Rest of your script continues here...





# Function to log messages
log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

# Update and install dependencies
log "Updating and upgrading packages..."
pkg update -y && pkg upgrade -y

log "Installing required dependencies..."
pkg install git make clang wget zip unzip curl jq -y

# Clone and compile John the Ripper
if [ ! -d "john" ]; then
    log "Cloning John the Ripper (bleeding-jumbo branch)..."
    git clone https://github.com/openwall/john -b bleeding-jumbo john
    cd john/src
    log "Configuring and compiling John the Ripper..."
    ./configure && make -s clean && make -sj4
    cd ~
else
    log "John the Ripper already exists, skipping compilation..."
fi

# Download popular wordlists
log "Downloading popular wordlists..."

# rockyou.txt - most popular wordlist
if [ ! -f "rockyou.txt" ]; then
    wget -O rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
fi

# Additional wordlists from various sources
wordlists=(
    "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-1000000.txt"
    "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt"
    "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt"
    "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/darkweb2017-top10000.txt"
    "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/best1050.txt"
)

for url in "${wordlists[@]}"; do
    filename=$(basename "$url")
    if [ ! -f "$filename" ]; then
        wget -O "$filename" "$url"
    fi
done

# Create custom wordlists
log "Creating custom wordlists..."

# Common passwords
cat > custom_passwords.txt << EOL
password
123456
123456789
qwerty
password1
admin
12345
12345678
111111
123123
admin123
letmein
welcome
monkey
password123
EOL

# Generate number sequences
seq 1900 2030 > years.txt
seq 1 100000 > numbers_1-100k.txt

echo -e "${GREEN}"
echo "=========================================="
echo "ZX Zip Pass Cracker PRO Installation Complete"
echo "Only for Educational Purpose"
echo "=========================================="
echo -e "${NC}"
