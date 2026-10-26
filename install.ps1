# Claude Code Offline Installer for Windows

Write-Host "Claude Code Offline Installer" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Check system architecture
if ([Environment]::Is64BitOperatingSystem -eq $false) {
    Write-Host "[ERROR] This installer requires 64-bit Windows" -ForegroundColor Red
    Write-Host "Your system is 32-bit and Claude Code only supports 64-bit Windows" -ForegroundColor Yellow
    exit 1
}

# Check PowerShell process architecture
if ([Environment]::Is64BitProcess -eq $false) {
    Write-Host "[ERROR] You are running 32-bit PowerShell" -ForegroundColor Red
    Write-Host "Claude Code requires 64-bit PowerShell" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please run this installer with 64-bit PowerShell:" -ForegroundColor Cyan
    Write-Host "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File `"$PSCommandPath`"" -ForegroundColor White
    Write-Host ""
    Write-Host "Or open 64-bit PowerShell directly (NOT 'Windows PowerShell (x86)')" -ForegroundColor Yellow
    exit 1
}

Write-Host "System: 64-bit Windows with 64-bit PowerShell" -ForegroundColor Green
Write-Host ""

# Create .local/bin directory
$binDir = "$env:USERPROFILE\.local\bin"
Write-Host "Creating directory: $binDir"
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

# Copy executable
$sourcePath = Join-Path $PSScriptRoot "claude.exe"
$destPath = Join-Path $binDir "claude.exe"

if (Test-Path $sourcePath) {
    Write-Host "Copying claude.exe to $binDir"
    Copy-Item -Path $sourcePath -Destination $destPath -Force
    Write-Host "[OK] Claude Code executable installed" -ForegroundColor Green
} else {
    Write-Host "[ERROR] claude.exe not found in installer directory" -ForegroundColor Red
    exit 1
}

# Check if already in PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binDir*") {
    Write-Host ""
    Write-Host "Adding $binDir to PATH..."
    $newPath = "$currentPath;$binDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "[OK] Added to PATH (restart your terminal to apply)" -ForegroundColor Green
} else {
    Write-Host "[OK] Already in PATH" -ForegroundColor Green
}

# Create .claude directory
$claudeDir = "$env:USERPROFILE\.claude"
Write-Host ""
Write-Host "Creating Claude config directory: $claudeDir"
New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null

# Create sample Bedrock configuration
$configPath = Join-Path $claudeDir "settings.json"
if (-not (Test-Path $configPath)) {
    Write-Host "Creating sample Bedrock configuration..."
    $sampleConfig = @{
        provider = "bedrock"
        bedrock = @{
            region = "us-east-1"
            profile = "default"
        }
        model = "anthropic.claude-sonnet-4-5-20250929-v1:0"
    } | ConvertTo-Json -Depth 10

    Set-Content -Path $configPath -Value $sampleConfig -Encoding UTF8
    Write-Host "[OK] Created sample configuration at $configPath" -ForegroundColor Green
    Write-Host "  Edit this file to customize your Bedrock settings" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Configuration already exists at $configPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart your terminal"
Write-Host "2. Configure AWS credentials (if not already done)"
Write-Host "3. Edit $configPath for your Bedrock setup"
Write-Host "4. Run: claude --version"
Write-Host ""
Write-Host "For Bedrock setup, see README.md" -ForegroundColor Yellow
