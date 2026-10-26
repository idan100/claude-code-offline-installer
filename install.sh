#!/bin/bash
# Claude Code Offline Installer for Linux/Mac/WSL

set -e

echo "Claude Code Offline Installer"
echo "============================="
echo ""

# Create .local/bin directory
BIN_DIR="$HOME/.local/bin"
echo "Creating directory: $BIN_DIR"
mkdir -p "$BIN_DIR"

# Copy executable
SOURCE_PATH="$(dirname "$0")/claude.exe"
DEST_PATH="$BIN_DIR/claude.exe"

if [ -f "$SOURCE_PATH" ]; then
    echo "Copying claude.exe to $BIN_DIR"
    cp "$SOURCE_PATH" "$DEST_PATH"
    chmod +x "$DEST_PATH"
    echo "✓ Claude Code executable installed"
else
    echo "✗ Error: claude.exe not found in installer directory"
    exit 1
fi

# Check if already in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo "Adding $BIN_DIR to PATH..."

    # Detect shell
    SHELL_RC=""
    if [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.profile"
    fi

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo "✓ Added to PATH in $SHELL_RC (restart terminal or run: source $SHELL_RC)"
else
    echo "✓ Already in PATH"
fi

# Create .claude directory
CLAUDE_DIR="$HOME/.claude"
echo ""
echo "Creating Claude config directory: $CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR"

# Create sample Bedrock configuration
CONFIG_PATH="$CLAUDE_DIR/settings.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Creating sample Bedrock configuration..."
    cat > "$CONFIG_PATH" <<'EOF'
{
  "provider": "bedrock",
  "bedrock": {
    "region": "us-east-1",
    "profile": "default"
  },
  "model": "anthropic.claude-sonnet-4-5-20250929-v1:0"
}
EOF
    echo "✓ Created sample configuration at $CONFIG_PATH"
    echo "  Edit this file to customize your Bedrock settings"
else
    echo "✓ Configuration already exists at $CONFIG_PATH"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source $SHELL_RC"
echo "2. Configure AWS credentials (if not already done)"
echo "3. Edit $CONFIG_PATH for your Bedrock setup"
echo "4. Run: claude.exe --version"
echo ""
echo "For Bedrock setup, see README.md"
