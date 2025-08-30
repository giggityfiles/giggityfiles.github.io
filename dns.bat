@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    pause
    exit /b
)

echo.
echo ==============================
echo   Configuring NextDNS (DoH)
echo ==============================
echo.

:: Change DNS on all connected interfaces
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| findstr "Connected"') do (
    set "iface=%%b"
    set "iface=!iface:~1!"
    echo Setting IP DNS for "!iface!"...
    netsh interface ip set dns name="!iface!" static 45.90.28.180
    netsh interface ip add dns name="!iface!" 45.90.30.18 index=2
)

:: Configure DNS-over-HTTPS (DoH)
echo.
echo Configuring DNS-over-HTTPS (DoH) for NextDNS...
netsh dns add encryption server=45.90.28.180 dohtemplate=https://dns.nextdns.io/7a485b autoupgrade=yes udpfallback=no
netsh dns add encryption server=45.90.30.18 dohtemplate=https://dns.nextdns.io/7a485b autoupgrade=yes udpfallback=no

:: Flush, release, and renew IP
echo.
echo Flushing and renewing IP...
ipconfig /flushdns
ipconfig /release
ipconfig /renew

:: Verify DoH configuration
echo.
echo Verifying DoH setup...
set doh_ok=no
for /f "tokens=*" %%a in ('netsh dns show encryption ^| findstr "dns.nextdns.io"') do (
    set doh_ok=yes
)

if "!doh_ok!"=="yes" (
    echo [SUCCESS] DNS over HTTPS is active for NextDNS.
    set result_msg=DNS (IP + DoH) successfully applied for NextDNS profile.
) else (
    echo [WARNING] DoH configuration failed or is unsupported on this Windows version.
    set result_msg=DNS changed, but DoH setup may have failed.
)

:: Open the NextDNS confirmation page
echo.
echo Opening confirmation page...
start "" "https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b"

:: Wait 10 seconds before closing browsers
echo.
echo Waiting 10 seconds before closing browsers...
timeout /t 10 /nobreak

:: Close browsers silently
echo.
echo Closing browsers...
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1
taskkill /f /im brave.exe >nul 2>&1
taskkill /f /im opera.exe >nul 2>&1
taskkill /f /im iexplore.exe >nul 2>&1

:: Final message
echo.
echo [DONE] !result_msg!
echo.
pause
