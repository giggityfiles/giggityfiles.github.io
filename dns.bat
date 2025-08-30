@echo off
:: NextDNS Setup Script - ID: 7a485b

set NEXTDNS_ID=7a485b
set PRIMARY=45.90.28.0
set SECONDARY=45.90.30.0
set LINK=https://link-ip.nextdns.io/%NEXTDNS_ID%/78b69e7bd5025e8b

:: Configure all connected interfaces
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| find "Connected"') do (
    set "intf=%%a"
    setlocal enabledelayedexpansion
    set "intf=!intf:~1!"

    :: Set primary and secondary DNS
    netsh interface ip set dns name="!intf!" static %PRIMARY%
    netsh interface ip add dns name="!intf!" %SECONDARY% index=2

    endlocal
)

:: Flush DNS cache
ipconfig /flushdns

:: Open NextDNS verification link
start "" "%LINK%"

:: Wait 5 seconds
timeout /t 5 /nobreak >nul

:: Close the browser window opened by this script
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1

exit
