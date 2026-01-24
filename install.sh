#!/bin/bash

# RustyBase Unix Installer
# Targets: macOS (intel/arm), Linux (x86_64)

set -e

REPO_URL="https://github.com/diptanshumahish/rustybase-release"
LATEST_RELEASE_API="https://api.github.com/repos/diptanshumahish/rustybase-release/releases/latest"

# Colors for output
CYAN='\033[0;36m'
BRIGHT_CYAN='\033[1;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Spinner implementation
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps -p $pid -o state= 2>/dev/null)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

print_banner() {
    echo -e "${BRIGHT_CYAN}"
    echo "░█████████                           ░██               ░██                                         "
    echo "░██     ░██                          ░██               ░██                                         "
    echo "░██     ░██ ░██    ░██  ░███████  ░████████ ░██    ░██ ░████████   ░██████    ░███████   ░███████  "
    echo "░█████████  ░██    ░██ ░██           ░██    ░██    ░██ ░██    ░██       ░██  ░██        ░██    ░██ "
    echo "░██   ░██   ░██    ░██  ░███████     ░██    ░██    ░██ ░██    ░██  ░███████   ░███████  ░█████████ "
    echo "░██    ░██  ░██   ░███        ░██    ░██    ░██   ░███ ░███   ░██ ░██   ░██         ░██ ░██        "
    echo "░██     ░██  ░█████░██  ░███████      ░████  ░█████░██ ░██░█████   ░█████░██  ░███████   ░███████  "
    echo "                                                   ░██                                             "
    echo "                                             ░███████                                              "
    echo -e "${NC}"
}

print_banner
echo -e "  ${CYAN}>> ${WHITE}Initiating RustyBase installation sequence...${NC}\n"

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) TARGET_ARCH="x86_64" ;;
    arm64|aarch64) TARGET_ARCH="aarch64" ;;
    *) 
        echo -e "  ${RED}[x] Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

case $OS in
    darwin) TARGET_OS="apple-darwin" ;;
    linux) TARGET_OS="unknown-linux-gnu" ;;
    *) 
        echo -e "  ${RED}[x] Unsupported OS: $OS${NC}"
        exit 1
        ;;
esac

TARGET="rustybase-$TARGET_ARCH-$TARGET_OS"

# Fetch latest release tag
printf "  ${CYAN}>> ${NC}Searching for latest release metadata... "
(curl -s "$LATEST_RELEASE_API" > "$TEMP_DIR/release.json") &
show_spinner $!
RELEASE_TAG=$(grep '"tag_name":' "$TEMP_DIR/release.json" | sed -E 's/.*"([^"]+)".*/\1/' | head -1)

if [ -z "$RELEASE_TAG" ]; then
    echo -e "\n  ${RED}[x] Error: Could not determine latest release version.${NC}"
    exit 1
fi

echo -e "${GREEN}[v]${NC} Identified: ${WHITE}$RELEASE_TAG${NC}"
DOWNLOAD_URL="$REPO_URL/releases/download/$RELEASE_TAG/$TARGET"

# Download binary
echo -e "  ${CYAN}>> ${NC}Pulling binary from production registry..."
if ! curl --progress-bar --fail -L -o "$TEMP_DIR/rustybase" "$DOWNLOAD_URL"; then
    echo -e "\n  ${RED}[x] Download failed. The binary for $TARGET could not be found.${NC}"
    echo -e "  ${YELLOW}[!] This usually means the build for this version is still in progress.${NC}"
    exit 1
fi

# Verify the file size
FILE_SIZE=$(stat -c%s "$TEMP_DIR/rustybase" 2>/dev/null || stat -f%z "$TEMP_DIR/rustybase" 2>/dev/null)
if [ "$FILE_SIZE" -lt 100000 ]; then
    echo -e "  ${RED}[x] Downloaded file validation failed (too small).${NC}"
    exit 1
fi

# Install binary
INSTALL_DIR="/usr/local/bin"
printf "  ${CYAN}>> ${NC}Deploying binary to $INSTALL_DIR... "

if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "\n  ${YELLOW}[!] Permission denied. Requesting elevated privileges...${NC}"
    sudo mv "$TEMP_DIR/rustybase" "$INSTALL_DIR/rustybase"
    sudo chmod +x "$INSTALL_DIR/rustybase"
else
    mv "$TEMP_DIR/rustybase" "$INSTALL_DIR/rustybase"
    chmod +x "$INSTALL_DIR/rustybase"
    echo -e "${GREEN}[v]${NC}"
fi

echo -e "\n${BRIGHT_CYAN}┌───────────────────────────────────────────────────────────┐${NC}"
echo -e "${BRIGHT_CYAN}│                                                           │${NC}"
echo -e "${BRIGHT_CYAN}│           INSTALLATION COMPLETE : RUSTYBASE               │${NC}"
echo -e "${BRIGHT_CYAN}└───────────────────────────────────────────────────────────┘${NC}"
echo -e "\n  ${WHITE}>> System operational. Server engine is now local.${NC}"
echo -e "  ${CYAN}>> Execute '${WHITE}rustybase init${CYAN}' to configure your instance.${NC}\n"
