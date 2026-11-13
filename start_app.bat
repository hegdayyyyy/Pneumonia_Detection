@echo off
setlocal
cd /d "%~dp0"

if exist ".streamlit.pid" (
    for /f "usebackq delims=" %%P in (".streamlit.pid") do (
        powershell -NoProfile -Command "if (Get-Process -Id %%P -ErrorAction SilentlyContinue) { exit 1 }"
        if not errorlevel 1 del ".streamlit.pid"
    )
)

if exist ".streamlit.pid" (
    echo The app is already running.
    start "" "http://localhost:8501"
    exit /b 0
)

powershell -NoProfile -Command "$p = Start-Process -FilePath '%~dp0.venv\Scripts\streamlit.exe' -ArgumentList @('run','src\app.py','--server.headless','true','--server.port','8501') -WorkingDirectory '%~dp0' -PassThru; Set-Content -Path '%~dp0.streamlit.pid' -Value $p.Id"
timeout /t 3 /nobreak >nul
start "" "http://localhost:8501"
echo The app is running at http://localhost:8501
