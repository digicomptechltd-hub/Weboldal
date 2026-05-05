# Auto-commit script – Digital Compliance Technology / Weboldal
# Futtatja a Windows Task Scheduler oranként

$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

$projectPath = "c:\Users\rluxu\Desktop\Claude Code\Test1"
$logFile     = "$projectPath\auto-commit.log"
$timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Set-Location $projectPath

# Ellenőrzés: van-e változás
$status = git status --porcelain
if (-not $status) {
    Add-Content $logFile "[$timestamp] Nincs változás, commit kihagyva."
    exit 0
}

git add .
$commitMsg = "Auto-mentés: $timestamp"
git commit -m $commitMsg
$pushResult = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Add-Content $logFile "[$timestamp] OK – push sikeres: $commitMsg"
} else {
    Add-Content $logFile "[$timestamp] HIBA – push sikertelen: $pushResult"
}
