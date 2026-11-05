@echo off
REM ============================================================
REM Local background launcher (ASCII-only on purpose: cmd parses
REM .bat files using the OEM codepage, UTF-8 Chinese comments
REM corrupt the line structure and break the whole script).
REM
REM Difference vs start_web_local.bat:
REM   start_web_local.bat = foreground; the cmd window IS the
REM                          service. Close it = service dies.
REM   this script         = start /b, detached. Close the window
REM                          and the service keeps running.
REM
REM Port 8790 (8765 is taken on this machine).
REM Usage: double-click -> window closes -> service runs in bg
REM         open http://127.0.0.1:8790
REM         stop with stop_web_local.bat
REM ============================================================
setlocal
cd /d "%~dp0"
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
set "WB_PORT=8790"

REM --- Python interpreter (prefer WorkBuddy bundled, then system) ---
set "PYC="
if exist "%USERPROFILE%\.workbuddy\binaries\python\versions\3.13.12\python.exe" (
    set "PYC=%USERPROFILE%\.workbuddy\binaries\python\versions\3.13.12\python.exe"
)
if not defined PYC if exist "%USERPROFILE%\.workbuddy-ai\binaries\python\versions\3.13.12\python.exe" (
    set "PYC=%USERPROFILE%\.workbuddy-ai\binaries\python\versions\3.13.12\python.exe"
)
if not defined PYC set "PYC=python"
if /i "%PYC%"=="python" (
    where python >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Python not found. Install Python 3 or set PYC in this script.
        pause
        exit /b 1
    )
)

set "LOG=%~dp0web_server.log"

REM --- start /b : run in background, survives parent window exit ---
REM     Do NOT escape the redirections with ^ here: that would pass
REM     a literal "^>" to the child process.
start "WorkBuddyCheckinWeb" /b "%PYC%" "%~dp0web_server.py" > "%LOG%" 2>&1

echo [OK] Checkin web server started in background (port 8790)
echo     log   : %LOG%
echo     local : http://127.0.0.1:8790
echo     stop  : run stop_web_local.bat
REM Sleep ~2s. ping is used instead of timeout.exe because timeout.exe
REM refuses to run when stdin is redirected ("input redirection not
REM supported"), which happens under some launchers.
ping -n 3 127.0.0.1 >nul
exit /b 0
