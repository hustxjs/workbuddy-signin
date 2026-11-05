@echo off
REM Stop the background checkin web server (started by start_web_bg.bat).
REM ASCII-only on purpose (see start_web_bg.bat for the reason).
setlocal
cd /d "%~dp0"

set "PID="
for /f "tokens=5" %%P in ('netstat -ano ^| findstr "LISTENING" ^| findstr ":8790"') do (
    if not defined PID set "PID=%%P"
)

if not defined PID (
    echo [OK] Nothing listening on 8790 - service was not running.
    exit /b 0
)

echo [STOP] PID %PID%
taskkill /PID %PID% /T /F >nul 2>&1
REM Sleep ~1s. ping is used instead of timeout.exe because timeout.exe
REM refuses to run when stdin is redirected ("input redirection not
REM supported"), which happens under some launchers.
ping -n 2 127.0.0.1 >nul
echo [OK] Stopped.
exit /b 0
