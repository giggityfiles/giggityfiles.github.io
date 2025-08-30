@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    echo Press any key to exit...
    pause >nul
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
    echo [INFO] Setting IP DNS for "!iface!"...
    netsh interface ip set dns name="!iface!" static 45.90.28.180
    netsh interface ip add dns name="!iface!" 45.90.30.18 index=2
)

echo.
echo [INFO] Adding DNS-over-HTTPS (DoH) profile for NextDNS...
netsh dns add encryption server=45.90.28.180 dohtemplate=https://dns.nextdns.io/7a485b autoupgrade=yes udpfallback=no
netsh dns add encryption server=45.90.30.18 dohtemplate=https://dns.nextdns.io/7a485b autoupgrade=yes udpfallback=no

echo.
echo [INFO] Flushing and renewing IP configuration...
ipconfig /flushdns
ipconfig /release
ipconfig /renew

echo.
echo [INFO] Verifying DoH configuration...
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

echo.
echo [INFO] Opening NextDNS confirmation page...
start "" "https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b"

echo.
echo [INFO] Waiting 10 seconds before closing browsers...
timeout /t 10 /nobreak

echo.
echo [INFO] Closing browsers...
taskkill /f /im chrome.exe
taskkill /f /im msedge.exe
taskkill /f /im firefox.exe
taskkill /f /im brave.exe
taskkill /f /im opera.exe
taskkill /f /im iexplore.exe

echo.
echo [DONE] !result_msg!
echo.
pause
