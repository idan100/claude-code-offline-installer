# Claude Code Offline Installer (with AWS Bedrock Support)

**Version:** 2.1.310

## Overview

This package provides Claude Code for offline installation on systems with AWS Bedrock access.

## Prerequisites

- **Windows 10/11 (64-bit REQUIRED)**
- AWS Bedrock access configured
- AWS credentials with appropriate permissions

**IMPORTANT:** Claude Code requires 64-bit Windows. 32-bit systems are not supported.

## Installation

### 1. Copy Files

Copy the entire `claude-code-offline-installer` directory to your offline machine.

### 2. Run Installation Script

```bash
# Using PowerShell
.\install.ps1

# Or manually:
# Create bin directory
mkdir -p ~/.local/bin

# Copy executable
cp claude.exe ~/.local/bin/

# Add to PATH if not already present
# Add C:\Users\<YourUsername>\.local\bin to system PATH
```

### 3. Configure for AWS Bedrock

Create or edit `~/.claude/settings.json`:

```json
{
  "provider": "bedrock",
  "bedrock": {
    "region": "us-east-1",
    "profile": "default"
  },
  "model": "anthropic.claude-sonnet-4-5-20250929-v1:0"
}
```

### 4. Set AWS Credentials

Ensure your AWS credentials are configured:

```bash
# Using AWS CLI config
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_REGION=us-east-1
```

### 5. Verify Installation

```bash
claude --version
```

## Available Bedrock Models

Configure in `~/.claude/settings.json`:

- `anthropic.claude-sonnet-4-5-20250929-v1:0` - Sonnet 4.5 (recommended)
- `anthropic.claude-opus-5-5-20250930-v1:0` - Opus 5.5 (most capable)
- `anthropic.claude-haiku-5-5-20250930-v1:0` - Haiku 5.5 (fast)
- `anthropic.claude-fable-5-1-20251003-v1:0` - Fable 5.1

## Configuration Examples

### Basic Bedrock Setup

```json
{
  "provider": "bedrock",
  "bedrock": {
    "region": "us-west-2",
    "profile": "bedrock-profile"
  }
}
```

### With Custom Model

```json
{
  "provider": "bedrock",
  "bedrock": {
    "region": "us-east-1"
  },
  "model": "anthropic.claude-opus-5-5-20250930-v1:0"
}
```

### With Proxy (if needed)

```json
{
  "provider": "bedrock",
  "bedrock": {
    "region": "us-east-1",
    "endpoint": "https://your-bedrock-proxy.internal"
  }
}
```

## Troubleshooting

### "claude: command not found"

Add `~/.local/bin` to your PATH:

**PowerShell (as Administrator):**
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\.local\bin", "User")
```

**Bash:**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### AWS Bedrock Authentication Issues

1. Verify AWS credentials: `aws sts get-caller-identity`
2. Ensure Bedrock is enabled in your region
3. Verify IAM permissions for `bedrock:InvokeModel`

### Required IAM Permissions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": "arn:aws:bedrock:*::foundation-model/anthropic.claude-*"
    }
  ]
}
```

## Support

For issues or questions:
- Claude Code documentation: https://docs.anthropic.com/claude/docs/claude-code
- AWS Bedrock documentation: https://docs.aws.amazon.com/bedrock/
