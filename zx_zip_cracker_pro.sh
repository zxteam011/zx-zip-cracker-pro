#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${RED}"
cat << "EOF"
   ███████ ██   ██ ███████ ██████  ███████ ███████
   ██       ██ ██  ██      ██   ██ ██      ██     
   █████     ███   █████   ██████  █████   █████  
   ██       ██ ██  ██      ██   ██ ██      ██     
   ███████ ██   ██ ███████ ██   ██ ███████ ███████
EOF
echo -e "${NC}"
echo -e "${YELLOW}ZX Zip Pass Cracker PRO - Only for Educational Purpose${NC}"
echo -e "${BLUE}=======================================================${NC}"

# Function to log messages
log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

# Function to crack zip file
crack_zip() {
    local zip_file="$1"
    
    log "Starting ZX Zip Pass Cracker PRO..."
    log "Target file: $zip_file"
    
    # Find zip2john
    ZIP2JOHN=$(find ~/john-old/run -name "zip2john" 2>/dev/null | head -1)
    if [ -z "$ZIP2JOHN" ]; then
        echo -e "${RED}Error: zip2john not found!${NC}"
        exit 1
    fi
    
    # Extract hash
    log "Extracting hash from $zip_file..."
    hash_file="${zip_file}.hash.txt"
    $ZIP2JOHN "$zip_file" > "$hash_file"
    
    if [ ! -s "$hash_file" ]; then
        echo -e "${RED}Error: Failed to extract hash from zip file${NC}"
        exit 1
    fi
    
    log "Hash extracted successfully: $hash_file"
    
    # Find john
    JOHN=$(find ~/john-old/run -name "john" 2>/dev/null | head -1)
    if [ -z "$JOHN" ]; then
        echo -e "${RED}Error: john not found!${NC}"
        exit 1
    fi
    
    # Define wordlists to try
    wordlists=(
        "custom_passwords.txt"
        "top-20-common-SSH-passwords.txt"
        "best1050.txt"
        "darkweb2017-top10000.txt"
        "10k-most-common.txt"
        "years.txt"
        "numbers_1-100k.txt"
        "10-million-password-list-top-1000000.txt"
        "rockyou.txt"
    )
    
    # Try built-in wordlists first
    password_found=""
    used_wordlist=""
    
    for wordlist in "${wordlists[@]}"; do
        if [ -f "$wordlist" ]; then
            log "Trying wordlist: $wordlist"
            echo -e "${YELLOW}Testing passwords, please wait...${NC}"
            
            # Run john with current wordlist
            timeout 300 $JOHN --wordlist="$wordlist" --format=zip "$hash_file" > /dev/null 2>&1
            
            # Check if password was found
            password_info=$($JOHN --show "$hash_file" 2>/dev/null)
            if echo "$password_info" | grep -q ":.*:"; then
                
                used_wordlist="$wordlist"
                break
            fi
            
            # Clear the pot file between attempts
            rm -f ~/.john/john.pot 2>/dev/null
        fi
    done
    password_found=$(echo "$password_info" | awk -F: '{print $2}')
    # Display results
    if [ -n "$password_found" ]; then
        echo -e "${GREEN}"
        echo "=========================================="
        echo "PASSWORD FOUND: $password_found"
        echo "Used wordlist: $used_wordlist"
        echo "=========================================="
        echo -e "${NC}"
        
        # Ask if user wants to extract the file
        read -p "Do you want to extract the file with this password? (y/n): " extract_choice
        if [ "$extract_choice" = "y" ] || [ "$extract_choice" = "Y" ]; then
            unzip -P "$password_found" "$zip_file"
            if [ $? -eq 0 ]; then
                log "File extracted successfully!"
            else
                log "Error extracting file!"
            fi
        fi
    else
        echo -e "${RED}"
        echo "=========================================="
        echo "PASSWORD NOT FOUND"
        echo "All wordlists exhausted"
        echo "=========================================="
        echo -e "${NC}"
    fi
    
    # Cleanup
    rm -f "$hash_file" 2>/dev/null
    rm -f ~/.john/john.pot 2>/dev/null
}

# Main execution
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}ZX Zip Pass Cracker PRO - Only for Educational Purpose${NC}"
    echo "Usage: $0 <zipfile>"
    echo ""
    echo "Available built-in wordlists:"
    ls -la *.txt 2>/dev/null | grep -v "hash.txt" | awk '{print $9}'
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
    echo -e "${RED}Error: File $1 not found!${NC}"
    exit 1
fi

# Start cracking process
crack_zip "$1"
