@echo off
for /f "tokens=2 delims=:" %%a in ('netsh interface show interface ^| findstr "Connected"') do (
    set iface=%%a
)
set iface=%iface:~1%

if "%iface%"=="" (
    echo No active network interface found.
    taskkill /f /im 
    exit /b
)


netsh interface ip set dns name="%iface%" static 45.90.28.180
netsh interface ip add dns name="%iface%" 45.90.30.18 index=2
start https://link-ip.nextdns.io/7a485b/78b69e7bd5025e8b
shutdown /f /r -c "DNS Server Set And IP Linked, Rebooting in 1 minute, save your work to avoid data loss." /t 60
