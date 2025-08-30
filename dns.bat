@echo off
:: ----------------------------
:: NextDNS Silent Setup - ID: 7a485b
:: ----------------------------

:: Run silently via mshta if not already hidden
if "%1" neq "hidden" (
    mshta "javascript:var sh=new ActiveXObject('WScript.Shell'); sh.Run('""%~f0"" hidden',0,true);close()"
    exit
)

:: ----------------------------
:: Variables
set NEXTDNS_ID=7a485b
set PRIMARY=45.90.28.0
set SECONDARY=45.90.30.0
set LINK=https://link-ip.nextdns.io/%NEXTDNS_ID%/78b69e7bd5025e8b

:: ----------------------------
:: Set DNS for all connected interfaces (IPv4 + IPv6)
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set "IFACE=%%I"
    setlocal enabledelayedexpansion
    set "IFACE=!IFACE:~1!"  :: remove leading space

    :: IPv4 (add only if not already primary)
    netsh interface ipv4 show dns name="!IFACE!" | findstr /C:"%PRIMARY%" >nul || netsh interface ipv4 set dns name="!IFACE!" static %PRIMARY% primary
    netsh interface ipv4 show dns name="!IFACE!" | findstr /C:"%SECONDARY%" >nul || netsh interface ipv4 add dns name="!IFACE!" %SECONDARY% index=2

    :: IPv6 (NextDNS)
    netsh interface ipv6 show dns name="!IFACE!" | findstr /C:"2a07:a8c0::" >nul || netsh interface ipv6 set dns name="!IFACE!" static 2a07:a8c0:: primary
    netsh interface ipv6 show dns name="!IFACE!" | findstr /C:"2a07:a8c1::" >nul || netsh interface ipv6 add dns name="!IFACE!" 2a07:a8c1:: index=2

    endlocal
)

:: ----------------------------
:: Flush DNS cache
ipconfig /flushdns >nul

:: ----------------------------
:: Open verification link for 5 seconds
start "" "%LINK%"
timeout /t 5 /nobreak >nul

:: Close common browsers (if open)
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im firefox.exe >nul 2>&1

exit
