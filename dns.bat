@echo off
setlocal enabledelayedexpansion

for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| findstr "Connected"') do (
    set iface=%%b
    set iface=!iface:~1!
    call :ChangeDNS "!iface!"
)

ipconfig /flushdns
ipconfig /release
ipconfig /renew

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v ServerPriorityTimeLimit /t REG_DWORD /d 0 /f >nul

shutdown /s /t 120 /c "System will shut down in 2 minutes after DNS change."
pause
exit /b

:ChangeDNS
netsh interface ip set dns name=%~1 static 45.90.28.180
netsh interface ip add dns name=%~1 45.90.30.18 index=2
exit /b
