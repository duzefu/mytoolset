#!/bin/bash

# Copy tools directory to home
cp -rf ./tools ~/

# Read configuration from external file
if [ -f "./bash_env" ]; then
    # Read the file content
    CONFIG_CONTENT=$(cat ./bash_env)
else
    echo "Error: ./bash_env configuration file not found!"
    exit 1
fi

# Wrap the content with markers
AGENT_BLOCK="### MANAGED_BY_AGENT_START
$CONFIG_CONTENT
### MANAGED_BY_AGENT_END"

BASHRC="$HOME/.bashrc"

# Function to update bashrc
update_bashrc() {
    if [ -f "$BASHRC" ]; then
        # Check if the marker already exists
        if grep -q "### MANAGED_BY_AGENT_START" "$BASHRC"; then
            echo "Found existing managed block in .bashrc, updating..."
            # Use awk to replace the content between markers
            awk -v new_block="$AGENT_BLOCK" '
                BEGIN { printing = 1 }
                /### MANAGED_BY_AGENT_START/ { printing = 0; print new_block; next }
                /### MANAGED_BY_AGENT_END/ { printing = 1; next }
                printing { print }
            ' "$BASHRC" > "${BASHRC}.tmp" && mv "${BASHRC}.tmp" "$BASHRC"
        else
            echo "Appending managed block to .bashrc..."
            # Add a newline just in case the file doesn't end with one
            echo "" >> "$BASHRC"
            echo "$AGENT_BLOCK" >> "$BASHRC"
        fi
    else
        echo ".bashrc not found, creating..."
        echo "$AGENT_BLOCK" > "$BASHRC"
    fi
}

update_bashrc

# Check and install dependencies
# Note: fd-find installs binary as 'fdfind' on Debian/Ubuntu usually
if ! command -v fdfind &> /dev/null; then
    echo "fdfind could not be found, installing fd-find..."
    sudo apt-get install -y fd-find
fi

# Note: ripgrep installs binary as 'rg'
if ! command -v rg &> /dev/null; then
    # Fallback check if user's previous script meant 'ripgrep' binary literally, 
    # but standard is 'rg'. checking 'rg' is safer.
    echo "rg could not be found, installing ripgrep..."
    sudo apt-get install -y ripgrep
fi

echo "Setup finished. Please reload your shell or run 'source ~/.bashrc'"
