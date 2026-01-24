#!/bin/bash

# RustyBase Unix Installer
# Targets: macOS (intel/arm), Linux (x86_64)

set -e

REPO_URL="https://github.com/diptanshumahish/rustybase-release"
LATEST_RELEASE_API="https://api.github.com/repos/diptanshumahish/rustybase-release/releases/latest"

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}>> Initiating RustyBase installation sequence...${NC}"

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) TARGET_ARCH="x86_64" ;;
    arm64|aarch64) TARGET_ARCH="aarch64" ;;
    *) 
        echo -e "${RED}[x] Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

case $OS in
    darwin) TARGET_OS="apple-darwin" ;;
    linux) TARGET_OS="unknown-linux-gnu" ;;
    *) 
        echo -e "${RED}[x] Unsupported OS: $OS${NC}"
        exit 1
        ;;
esac

TARGET="rustybase-$TARGET_ARCH-$TARGET_OS"

# Fetch latest release tag
echo -e "${CYAN}>> Searching for latest release metadata...${NC}"
RELEASE_TAG=$(curl -s "$LATEST_RELEASE_API" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -1)

if [ -z "$RELEASE_TAG" ]; then
    echo -e "${RED}[x] Error: Could not determine latest release version.${NC}"
    exit 1
fi

echo -e "${CYAN}>> Version identified: $RELEASE_TAG${NC}"
DOWNLOAD_URL="$REPO_URL/releases/download/$RELEASE_TAG/$TARGET"

# Download binary
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${CYAN}>> Pulling binary from production registry...${NC}"
curl -L -o "$TEMP_DIR/rustybase" "$DOWNLOAD_URL" || {
    echo -e "${RED}[x] Download failed. Please check your internet connection.${NC}"
    exit 1
}

# Install binary
INSTALL_DIR="/usr/local/bin"
echo -e "${CYAN}>> Deploying binary to $INSTALL_DIR...${NC}"

if [ ! -w "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}[!] Permission denied. Requesting elevated privileges...${NC}"
    sudo mv "$TEMP_DIR/rustybase" "$INSTALL_DIR/rustybase"
    sudo chmod +x "$INSTALL_DIR/rustybase"
else
    mv "$TEMP_DIR/rustybase" "$INSTALL_DIR/rustybase"
    chmod +x "$INSTALL_DIR/rustybase"
fi

echo -e "\n${GREEN}>> Deployment successful. RustyBase engine is now offline but ready.${NC}"
echo -e "${CYAN}>> Execute 'rustybase init' to configure your first instance.${NC}\n"
