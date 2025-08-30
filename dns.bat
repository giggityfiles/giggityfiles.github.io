@echo off
set PRIMARY=45.90.28.0
set SECONDARY=45.90.30.0
set LINK=https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b

ipconfig /flushdns

netsh interface show interface | findstr /R /C:"Connected"

for /f "skip=3 tokens=4*" %%I in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set "IFACE=%%I %%J"
    setlocal enabledelayedexpansion
    netsh interface ipv4 set dns name="!IFACE!" static %PRIMARY% primary
    netsh interface ipv4 add dns name="!IFACE!" %SECONDARY% index=2
    endlocal
)

start "" "%LINK%"
pause
