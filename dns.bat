@echo off
:: ----------------------------
:: Safe NextDNS Setup Script
:: ----------------------------
:: Must run as Administrator

:: ============================
:: Configuration
set PRIMARY=45.90.28.0
set SECONDARY=45.90.30.0
:: Paste your full NextDNS verification link here (with device hash)
set LINK=https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b

echo Flushing DNS cache first...
ipconfig /flushdns

echo Setting NextDNS for all connected interfaces...

:: ============================
:: Loop through all connected adapters
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set "IFACE=%%I"
    setlocal enabledelayedexpansion
    set "IFACE=!IFACE:~1!"  :: remove leading space

    echo Configuring adapter "!IFACE!"...

    :: IPv4 DNS (only set if not already present)
    netsh interface ipv4 show dns name="!IFACE!" | findstr /C:"%PRIMARY%" >nul || netsh interface ipv4 set dns name="!IFACE!" static %PRIMARY% primary
    netsh interface ipv4 show dns name="!IFACE!" | findstr /C:"%SECONDARY%" >nul || netsh interface ipv4 add dns name="!IFACE!" %SECONDARY% index=2

    endlocal
)

:: ============================
echo Done setting DNS.

:: Open verification link
echo Opening NextDNS verification page...
start "" "%LINK%"

echo Finished! Verify your setup in the browser that just opened.
pause
