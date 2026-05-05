# Auto-commit script - Digital Compliance Technology / Weboldal
# Futtatja a Windows Task Scheduler oranként

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

$projectPath = "c:\Users\rluxu\Desktop\Claude Code\Test1"
$logFile     = "$projectPath\auto-commit.log"
$timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Set-Location $projectPath

$status = git status --porcelain
if (-not $status) {
    Add-Content -Path $logFile -Value "[$timestamp] Nincs valtozas, commit kihagyva." -Encoding UTF8
    exit 0
}

git add .
$commitMsg = "Auto-mentes: $timestamp"
git commit -m $commitMsg
$pushResult = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Add-Content -Path $logFile -Value "[$timestamp] OK - push sikeres: $commitMsg" -Encoding UTF8
} else {
    Add-Content -Path $logFile -Value "[$timestamp] HIBA - push sikertelen: $pushResult" -Encoding UTF8
}
