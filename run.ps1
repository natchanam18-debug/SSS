$folder = "$env:TEMP\Hadestoolv2"
if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder | Out-Null }

$zipUrl = "https://github.com/natchanam18-debug/SSS/releases/download/v1.0.2/app.zip"
$zipPath = "$env:TEMP\app.zip"

Write-Host "กำลังดาวน์โหลดโปรแกรม..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

Write-Host "กำลังเตรียมไฟล์..." -ForegroundColor Cyan
Expand-Archive -Path $zipPath -DestinationPath $folder -Force

Write-Host "กำลังเปิดโปรแกรม..." -ForegroundColor Green
Start-Process "$folder\Hadestoolv2.exe"
