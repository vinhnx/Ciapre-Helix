#!/bin/bash

# Ciapre Helix Themes Setup Script
# This script automatically installs the Ciapre themes to your Helix configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Ciapre Helix Themes...${NC}\n"

# Determine Helix config directory
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    HELIX_CONFIG_DIR="$APPDATA/helix"
    if [ -z "$HELIX_CONFIG_DIR" ]; then
        # Fallback for Windows if APPDATA is not set
        HELIX_CONFIG_DIR="$USERPROFILE/AppData/Roaming/helix"
    fi
else
    # Unix-like (Linux, macOS)
    HELIX_CONFIG_DIR="$HOME/.config/helix"
fi

echo -e "${YELLOW}Detected Helix config directory: $HELIX_CONFIG_DIR${NC}"

# Check if Helix config directory exists
if [ ! -d "$HELIX_CONFIG_DIR" ]; then
    echo -e "${RED}Error: Helix configuration directory not found at $HELIX_CONFIG_DIR${NC}"
    echo -e "${RED}Please ensure Helix is installed before running this script.${NC}"
    exit 1
fi

# Create themes directory if it doesn't exist
THEMES_DIR="$HELIX_CONFIG_DIR/themes"
mkdir -p "$THEMES_DIR"

# Copy theme files
echo -e "${BLUE}Copying theme files...${NC}"
cp ciapre.toml "$THEMES_DIR/"
cp ciapreblack.toml "$THEMES_DIR/"

echo -e "${GREEN}Successfully installed Ciapre and CiapreBlack themes!${NC}"

# Ask if user wants to set a default theme
echo -e "\n${YELLOW}Would you like to set one of these themes as default?${NC}"
echo "1) Ciapre"
echo "2) CiapreBlack"
echo "3) No, I'll set it up manually later"

read -p "Select an option (1-3): " choice

CONFIG_FILE="$HELIX_CONFIG_DIR/config.toml"

case $choice in
    1)
        # Create config.toml if it doesn't exist
        if [ ! -f "$CONFIG_FILE" ]; then
            echo "# Helix configuration" > "$CONFIG_FILE"
            echo "[editor]" >> "$CONFIG_FILE"
        fi
        
        # Add or update theme configuration
        if grep -q "^\[theme\]" "$CONFIG_FILE"; then
            # Update existing theme config
            sed -i.bak "s/default = .*/default = \"ciapre\"/" "$CONFIG_FILE"
            rm -f "$CONFIG_FILE.bak"
        else
            # Add new theme config
            echo "" >> "$CONFIG_FILE"
            echo "[theme]" >> "$CONFIG_FILE"
            echo "default = \"ciapre\"" >> "$CONFIG_FILE"
        fi
        echo -e "${GREEN}Set Ciapre as the default theme in $CONFIG_FILE${NC}"
        ;;
    2)
        # Create config.toml if it doesn't exist
        if [ ! -f "$CONFIG_FILE" ]; then
            echo "# Helix configuration" > "$CONFIG_FILE"
            echo "[editor]" >> "$CONFIG_FILE"
        fi
        
        # Add or update theme configuration
        if grep -q "^\[theme\]" "$CONFIG_FILE"; then
            # Update existing theme config
            sed -i.bak "s/default = .*/default = \"ciapreblack\"/" "$CONFIG_FILE"
            rm -f "$CONFIG_FILE.bak"
        else
            # Add new theme config
            echo "" >> "$CONFIG_FILE"
            echo "[theme]" >> "$CONFIG_FILE"
            echo "default = \"ciapreblack\"" >> "$CONFIG_FILE"
        fi
        echo -e "${GREEN}Set CiapreBlack as the default theme in $CONFIG_FILE${NC}"
        ;;
    3)
        echo -e "${YELLOW}You can set your theme manually later by editing $CONFIG_FILE${NC}"
        ;;
    *)
        echo -e "${YELLOW}Invalid option. You can set your theme manually later by editing $CONFIG_FILE${NC}"
        ;;
esac

echo -e "\n${GREEN}Setup complete! Restart Helix to see the changes.${NC}"
echo -e "${YELLOW}To use a specific theme when opening Helix, you can also use:${NC}"
echo "hx --theme ciapre"
echo "hx --theme ciapreblack"