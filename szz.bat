taskkill /f /im explorer.exe
echo launching firefox
start firefox --kiosk https://giggityfiles.github.io/seized
echo this might have failed
timeout 5 /nobreak
exit
