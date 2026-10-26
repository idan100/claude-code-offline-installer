# Claude Code Offline Installer for Windows

Write-Host "Claude Code Offline Installer" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
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
    Write-Host "âœ“ Claude Code executable installed" -ForegroundColor Green
} else {
    Write-Host "âœ— Error: claude.exe not found in installer directory" -ForegroundColor Red
    exit 1
}

# Check if already in PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binDir*") {
    Write-Host ""
    Write-Host "Adding $binDir to PATH..."
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$currentPath;$binDir",
        "User"
    )
    Write-Host "âœ“ Added to PATH (restart your terminal to apply)" -ForegroundColor Green
} else {
    Write-Host "âœ“ Already in PATH" -ForegroundColor Green
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
    Write-Host "âœ“ Created sample configuration at $configPath" -ForegroundColor Green
    Write-Host "  Edit this file to customize your Bedrock settings" -ForegroundColor Yellow
} else {
    Write-Host "âœ“ Configuration already exists at $configPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart your terminal or run: `$env:Path += `";$binDir`""
Write-Host "2. Configure AWS credentials (if not already done)"
Write-Host "3. Edit $configPath for your Bedrock setup"
Write-Host "4. Run: claude --version"
Write-Host ""
Write-Host "For Bedrock setup, see README.md" -ForegroundColor Yellow
