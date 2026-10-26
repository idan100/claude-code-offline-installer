# Troubleshooting Guide

## "This program can't start - incompatibility with 64-bit version"

### Cause
You're running **32-bit PowerShell** on 64-bit Windows. Claude Code requires 64-bit PowerShell.

### Check Which PowerShell You're Using

```powershell
[Environment]::Is64BitProcess
```

- **False** = 32-bit PowerShell (wrong - causes the error)
- **True** = 64-bit PowerShell (correct)

### Solution: Use 64-bit PowerShell

#### Option 1: Launch 64-bit PowerShell Directly

```powershell
# Close current PowerShell and open:
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

Or search for **"Windows PowerShell"** (not "Windows PowerShell (x86)")

#### Option 2: Run Installer with 64-bit PowerShell

```powershell
# From any command prompt:
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\path\to\install.ps1"
```

#### How to Tell Them Apart

- **64-bit PowerShell**: Window title shows just "Windows PowerShell"
- **32-bit PowerShell**: Window title shows "Windows PowerShell (x86)"

---

## Verify Installation After Using 64-bit PowerShell

```powershell
# Check PowerShell is 64-bit
[Environment]::Is64BitProcess
# Should return: True

# Run installer
.\install.ps1

# After installation, verify
claude --version
```

---

## Other Common Issues

### "claude: command not found"

Restart your PowerShell session:
```powershell
# Close and reopen PowerShell, or:
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### AWS Bedrock Authentication Errors

```powershell
# Verify AWS credentials
aws sts get-caller-identity

# Check Bedrock access
aws bedrock list-foundation-models --region us-east-1
```

### File Corruption During Transfer

Re-download or verify file integrity:
```powershell
Get-FileHash claude.exe -Algorithm SHA256
# Should be: (varies by version - check with source machine)
```

---

## System Requirements Checklist

- [x] Windows 10/11 (64-bit)
- [x] 64-bit PowerShell process
- [x] AWS credentials configured
- [x] Bedrock access in target region
- [x] IAM permissions for `bedrock:InvokeModel`
