#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                           ║${NC}"
echo -e "${BLUE}║     ██████╗ ██╗   ██╗███████╗████████╗██╗   ██╗██████╗  █████╗ ███████╗███████╗${NC}"
echo -e "${BLUE}║     ██╔══██╗██║   ██║██╔════╝╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██╔════╝${NC}"
echo -e "${BLUE}║     ██████╔╝██║   ██║███████╗   ██║    ╚████╔╝ ██████╔╝███████║███████╗█████╗  ${NC}"
echo -e "${BLUE}║     ██╔══██╗██║   ██║╚════██║   ██║     ╚██╔╝  ██╔══██╗██╔══██║╚════██║██╔══╝  ${NC}"
echo -e "${BLUE}║     ██║  ██║╚██████╔╝███████║   ██║      ██║   ██████╔╝██║  ██║███████║███████╗${NC}"
echo -e "${BLUE}║     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝${NC}"
echo -e "${BLUE}║                                                                           ║${NC}"
echo -e "${BLUE}║                    ██████╗ █████╗ ███████╗███████╗                        ║${NC}"
echo -e "${BLUE}║                   ██╔════╝██╔══██╗██╔════╝██╔════╝                        ║${NC}"
echo -e "${BLUE}║                   ██║     ███████║███████╗███████╗                        ║${NC}"
echo -e "${BLUE}║                   ██║     ██╔══██║╚════██║╚════██║                        ║${NC}"
echo -e "${BLUE}║                   ╚██████╗██║  ██║███████║███████║                        ║${NC}"
echo -e "${BLUE}║                    ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝                        ║${NC}"
echo -e "${BLUE}║                                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗${NC}"
echo -e "${GREEN}    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝${NC}"
echo -e "${GREEN}    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ███████╗${NC}"
echo -e "${GREEN}    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ╚════██║${NC}"
echo -e "${GREEN}    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████║${NC}"
echo -e "${GREEN}    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝${NC}"
echo ""
echo -e "${BLUE}    ═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │${NC}"
echo -e "${BLUE}    │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │${NC}"
echo -e "${BLUE}    │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │${NC}"
echo -e "${BLUE}    │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │${NC}"
echo -e "${BLUE}    │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │${NC}"
echo -e "${BLUE}    │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │${NC}"
echo -e "${BLUE}    ═══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}    ════  ██╗ ██╗ ██████╗ ██╗   ██╗███████╗██████╗  ════${NC}"
echo -e "${YELLOW}    ════  ██║ ██║██╔═══██╗██║   ██║██╔════╝██╔══██╗ ════${NC}"
echo -e "${YELLOW}    ════  ██████║██║   ██║██║   ██║█████╗  ██████╔╝ ════${NC}"
echo -e "${YELLOW}    ════  ██╔══██║██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗ ════${NC}"
echo -e "${YELLOW}    ════  ██║  ██║╚██████╔╝ ╚████╔╝ ███████╗██║  ██║ ════${NC}"
echo -e "${YELLOW}    ════  ╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝ ════${NC}"
echo ""

check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

check_rust() {
    echo -e "${YELLOW}Checking for Rust installation...${NC}"
    if check_command rustc && check_command cargo; then
        RUST_VERSION=$(rustc --version)
        echo -e "${GREEN}✓ Found: $RUST_VERSION${NC}"
        return 0
    else
        echo -e "${RED}✗ Rust is not installed${NC}"
        echo -e "${YELLOW}Please install Rust from: https://rustup.rs/${NC}"
        exit 1
    fi
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    echo -e "${BLUE}Detected OS: $OS${NC}"
}

install_binary() {
    echo ""
    echo -e "${YELLOW}Building RustyBase in release mode...${NC}"
    
    if [ ! -f "Cargo.toml" ]; then
        echo -e "${RED}✗ Cargo.toml not found. Are you in the project root?${NC}"
        exit 1
    fi
    
    cargo build --release
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Build failed${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Build successful${NC}"
    
    BINARY_PATH="target/release/rustybase"
    
    if [ ! -f "$BINARY_PATH" ]; then
        echo -e "${RED}✗ Binary not found at $BINARY_PATH${NC}"
        exit 1
    fi
    
    INSTALL_DIR="/usr/local/bin"
    
    if [ ! -w "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}Requiring sudo permissions to install to $INSTALL_DIR${NC}"
        sudo cp "$BINARY_PATH" "$INSTALL_DIR/rustybase"
        sudo chmod +x "$INSTALL_DIR/rustybase"
    else
        cp "$BINARY_PATH" "$INSTALL_DIR/rustybase"
        chmod +x "$INSTALL_DIR/rustybase"
    fi
    
    echo -e "${GREEN}✓ RustyBase installed to $INSTALL_DIR/rustybase${NC}"
    
    if check_command rustybase; then
        INSTALLED_VERSION=$(rustybase --version 2>/dev/null || echo "installed")
        echo -e "${GREEN}✓ Installation verified${NC}"
    fi
}

main() {
    check_rust
    detect_os
    install_binary
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║          ✅  Installation Complete!  ✅                   ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo -e "  ${YELLOW}rustybase init${NC}   - Initialize a new RustyBase instance"
    echo -e "  ${YELLOW}rustybase serve${NC}  - Start the API server"
    echo ""
}

main "$@"
