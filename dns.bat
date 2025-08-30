@echo off
setlocal enabledelayedexpansion

:: Change DNS on all connected interfaces
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| findstr "Connected"') do (
    set iface=%%b
    set iface=!iface:~1!
    netsh interface ip set dns name=!iface! static 45.90.28.180 >nul 2>&1
    netsh interface ip add dns name=!iface! 45.90.30.18 index=2 >nul 2>&1
)

:: Flush, release, and renew IP silently
ipconfig /flushdns >nul 2>&1
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1

:: Open the NextDNS link silently
start "" "https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b"

:: Wait 10 seconds, then kill browser processes (internet explorer just in case)
timeout /t 10 /nobreak >nul
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1
taskkill /f /im brave.exe >nul 2>&1
taskkill /f /im opera.exe >nul 2>&1
taskkill /f /im iexplore.exe >nul 2>&1


msg "DNS changed successfully. possibly..."
