@echo off
echo are you sure you wanna do this? this will kill the taskbar.
timeout /t -1
taskkill /f /im explorer.exe
echo launching chrome
start chrome --kiosk https://giggityfiles.github.io/seized
