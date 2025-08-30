@echo off
set PRIMARY=45.90.28.180
set SECONDARY=45.90.30.180
set LINK=https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b

ipconfig /flushdns

for /f "skip=3 tokens=4*" %%I in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set "IFACE=%%I %%J"
    setlocal enabledelayedexpansion
    netsh interface ipv4 set dns name="!IFACE!" static %PRIMARY% primary
    netsh interface ipv4 add dns name="!IFACE!" %SECONDARY% index=2
    netsh interface ipv6 set dns name="!IFACE!" static 2a07:a8c0:: primary
    netsh interface ipv6 add dns name="!IFACE!" 2a07:a8c1:: index=2
    endlocal
)

set POLICIES_DIR=%ProgramFiles%\Mozilla Firefox\distribution
if not exist "%POLICIES_DIR%" mkdir "%POLICIES_DIR%"
(
echo {
echo   "policies": {
echo     "DNSOverHTTPS": {
echo       "Enabled": true,
echo       "Templates": ["https://dns.nextdns.io/7a485b"]
echo     }
echo   }
echo }
) > "%POLICIES_DIR%\policies.json"

start "" "%LINK%"
start chrome --host-resolver-rules="MAP * 45.90.28.180, MAP * 45.90.30.180"
start msedge --host-resolver-rules="MAP * 45.90.28.180, MAP * 45.90.30.180"
pause
