# Microsoft Teams Cleanup and Deploy

這個專案包含兩個 PowerShell 腳本，用於清理和重新部署 Microsoft Teams。

## 管理員版本和非管理員版本的差異

### 管理員版本特點
- 可以移除所有使用者的 Teams 應用程式
- 可以清理系統層級的 Teams 檔案
- 可以移除所有使用者的 Microsoft Store 版 Teams
- 需要系統管理員權限才能執行
- 適合 IT 管理員在企業環境中使用

### 非管理員版本特點
- 只能移除當前使用者的 Teams 應用程式
- 只能清理當前使用者的 Teams 檔案
- 只能移除當前使用者的 Microsoft Store 版 Teams
- 不需要特殊權限即可執行
- 適合一般使用者在個人電腦上使用

## 腳本說明

1. `TeamsCleanupAdmin.ps1` - 管理員版本
   - 需要管理員權限執行
   - 可以移除所有使用者的 Teams
   - 清理系統級的 Teams 檔案

2. `TeamsCleanup.ps1` - 一般使用者版本
   - 不需要管理員權限
   - 只清理當前使用者的 Teams
   - 適合一般使用者使用

## 功能

- 移除舊版 Teams
- 清理 Teams 相關檔案
- 安裝最新版本的 Teams
- 自動啟動 Teams
- 設定開機自動啟動

## 使用方式

### 管理員版本
1. 以系統管理員身份開啟 PowerShell
2. 執行 `TeamsCleanupAdmin.ps1`

### 一般使用者版本
1. 直接開啟 PowerShell
2. 執行 `TeamsCleanup.ps1`

## 注意事項

- 執行腳本前請先儲存重要資料
- 腳本執行過程中會關閉所有 Teams 進程
- 需要網際網路連線以下載最新版本的 Teams
