@echo off
:: NextDNS DoH Setup Script - ID: 7a485b
:: Must be run as administrator

set NEXTDNS_ID=7a485b
set PRIMARY=45.90.28.0
set SECONDARY=45.90.30.0
set DOH_URL=https://dns.nextdns.io/%NEXTDNS_ID%
set LINK=https://link-ip.nextdns.io/%NEXTDNS_ID%/78b69e7bd5025e8b

:: Configure all connected interfaces
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| find "Connected"') do (
    set "intf=%%a"
    setlocal enabledelayedexpansion
    set "intf=!intf:~1!"

    :: Set primary and secondary DNS
    netsh interface ip set dns name="!intf!" static %PRIMARY%
    netsh interface ip add dns name="!intf!" %SECONDARY% index=2

    :: Enable DoH
    netsh dns add encryption server=%PRIMARY% dohtemplate=%DOH_URL% autoupgrade=yes
    netsh dns add encryption server=%SECONDARY% dohtemplate=%DOH_URL% autoupgrade=yes

    endlocal
)

:: Flush DNS cache
ipconfig /flushdns

:: Open NextDNS verification link
start "" "%LINK%"

:: Wait 5 seconds
timeout /t 5 /nobreak >nul

:: Close the browser window opened by this script
:: (This will close all instances of the default browser; for finer control, you may need PowerShell)
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1

exit
