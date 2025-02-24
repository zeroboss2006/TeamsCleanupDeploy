# 確認是否已經取得管理員權限
$runAsAdmin = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $runAsAdmin.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "此腳本需要以管理員身份運行。"
    Exit
}

# Step 1: 移除當前使用者的舊版 Teams
Write-Host "正在移除當前使用者的舊版 Teams..."

# 關閉所有 Teams 進程
Write-Host "正在關閉 Teams 進程..."
taskkill /F /IM Teams.exe /T 2> $null

# 移除 Microsoft Store 版 Teams（針對所有使用者）
Write-Host "正在移除 Microsoft Store 版 Teams..."
Get-AppxPackage -AllUsers *Microsoft.Teams* | Remove-AppxPackage

# 移除傳統版 Teams（針對所有使用者）
Write-Host "正在移除傳統版 Teams..."
winget uninstall --id Microsoft.Teams --silent --force 2> $null

# 清理 Teams 殘留檔案
Write-Host "清理所有 Teams 殘留檔案..."
Remove-Item -Path "C:\Users\*\AppData\Roaming\Microsoft\Teams" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\*\AppData\Local\Microsoft\Teams" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Microsoft\Teams" -Recurse -Force -ErrorAction SilentlyContinue

# Step 2: 安裝最新版本的 Microsoft Teams（從 Microsoft Store 安裝）
Write-Host "正在安裝最新版本的 Microsoft Teams..."
winget source update  # 更新 winget 來源
winget install --id Microsoft.Teams --silent --accept-source-agreements 2> $null

# Step 3: 啟動 Teams
Write-Host "正在啟動 Teams..."

# Teams 的安裝路徑
$teamsExePath = "$env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe"

# 檢查 Teams 是否已經安裝
if (Test-Path $teamsExePath) {
    Write-Host "正在啟動 Teams..."
    Start-Process -FilePath $teamsExePath
} else {
    Write-Host "未能找到 Teams 安裝路徑，請手動安裝 Teams。"
}

# Step 4: 設定 Teams 為啟動項目（讓每個使用者登錄時自動啟動 Teams）
Write-Host "正在設定 Teams 為啟動項目..."

# 確保每個使用者的啟動資料夾存在
$startupPath = [System.Environment]::GetFolderPath('Startup')

# 檢查啟動資料夾並將 Teams 快捷方式添加到該資料夾
$teamsShortcutPath = "$startupPath\Teams.lnk"

# 檢查 Teams 是否已經在啟動項目中，若無則創建快捷方式
if (!(Test-Path $teamsShortcutPath)) {
    Write-Host "正在創建 Teams 快捷方式..."
    $wsh = New-Object -ComObject WScript.Shell
    $shortcut = $wsh.CreateShortcut($teamsShortcutPath)
    $shortcut.TargetPath = $teamsExePath
    $shortcut.Save()
}

Write-Host "完成！Teams 已安裝並設定為啟動項目，且會在每次登入時啟動。"
Write-Host "Teams 已經在本次會話中啟動。"

# 等待使用者按下 Enter 鍵以結束腳本
Write-Host "按 Enter 鍵以結束..."
$null = Read-Host