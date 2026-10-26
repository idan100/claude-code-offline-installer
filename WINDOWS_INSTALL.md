# Windows Installation Guide

## Quick Start

### 1. Download from GitHub

On a machine **with internet access**:

```powershell
git clone https://github.com/idan100/claude-code-offline-installer.git
```

Or download as ZIP: https://github.com/idan100/claude-code-offline-installer/archive/refs/heads/master.zip

### 2. Transfer to Offline Machine

Copy the entire `claude-code-offline-installer` folder to your offline Windows machine via USB drive, network share, or other approved method.

### 3. Run Installer

On the offline machine, open PowerShell and run:

```powershell
cd path\to\claude-code-offline-installer
.\install.ps1
```

**Note:** If you get an execution policy error, run:
```powershell
PowerShell -ExecutionPolicy Bypass -File .\install.ps1
```

### 4. Configure AWS Bedrock

The installer creates `~/.claude/settings.json` with default Bedrock settings. Edit if needed:

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

### 5. Set AWS Credentials

Ensure AWS credentials are configured on the offline machine:

**Option A - AWS CLI:**
```powershell
aws configure
```

**Option B - Environment Variables:**
```powershell
$env:AWS_ACCESS_KEY_ID = "your_access_key"
$env:AWS_SECRET_ACCESS_KEY = "your_secret_key"
$env:AWS_REGION = "us-east-1"
```

**Option C - Credentials File:**

Create/edit `~\.aws\credentials`:
```
[default]
aws_access_key_id = your_access_key
aws_secret_access_key = your_secret_key
```

Create/edit `~\.aws\config`:
```
[default]
region = us-east-1
```

### 6. Test Installation

```powershell
# Restart PowerShell, then:
claude --version
```

## Troubleshooting

### "claude is not recognized..."

Restart PowerShell or add to PATH manually:
```powershell
$env:Path += ";$env:USERPROFILE\.local\bin"
```

Make it permanent:
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\.local\bin", "User")
```

### Bedrock Connection Issues

Verify Bedrock access:
```powershell
# Check AWS identity
aws sts get-caller-identity

# Check Bedrock regions
aws bedrock list-foundation-models --region us-east-1
```

Ensure your IAM role/user has these permissions:
- `bedrock:InvokeModel`
- `bedrock:InvokeModelWithResponseStream`

## What Gets Installed

- `~/.local/bin/claude.exe` - Claude Code executable (284 MB)
- `~/.claude/settings.json` - Bedrock configuration
- PATH updated to include `~/.local/bin`

## Version

Claude Code v2.1.310
