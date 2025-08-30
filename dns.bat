@echo off
:: NextDNS DoH Setup Script - ID: 7a485b
:: Must be run as administrator

echo Configuring DNS settings for NextDNS with DoH...
set NEXTDNS_ID=7a485b
set PRIMARY=45.90.28.0
set SECONDARY=45.90.30.0
set DOH_URL=https://dns.nextdns.io/%NEXTDNS_ID%

:: Loop through all connected interfaces
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| find "Connected"') do (
    set "intf=%%a"
    setlocal enabledelayedexpansion
    set "intf=!intf:~1!"
    echo Setting DNS for interface "!intf!"...

    :: Set primary and secondary DNS
    netsh interface ip set dns name="!intf!" static %PRIMARY%
    netsh interface ip add dns name="!intf!" %SECONDARY% index=2

    :: Add DoH server template
    echo Adding DoH template for "!intf!"...
    netsh dns add encryption server=%PRIMARY% dohtemplate=%DOH_URL% autoupgrade=yes
    netsh dns add encryption server=%SECONDARY% dohtemplate=%DOH_URL% autoupgrade=yes

    endlocal
)

:: Flush DNS cache
ipconfig /flushdns
echo.
echo Done! Your DNS is now NextDNS with DoH enabled.
pause
