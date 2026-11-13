@echo off
setlocal
cd /d "%~dp0"

if not exist ".streamlit.pid" (
    echo The app is not running.
    exit /b 0
)

for /f "usebackq delims=" %%P in (".streamlit.pid") do set "APP_PID=%%P"
powershell -NoProfile -Command "$appProcessId = [int]'%APP_PID%'; if (Get-Process -Id $appProcessId -ErrorAction SilentlyContinue) { Stop-Process -Id $appProcessId }"
del ".streamlit.pid"
echo The app has been stopped.
