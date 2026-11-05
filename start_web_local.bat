@echo off
REM ============================================================
REM Local foreground launcher (ASCII-only on purpose: cmd parses
REM .bat files using the OEM codepage; UTF-8 Chinese comments
REM corrupt the line structure and break the script).
REM
REM Port 8790 (8765 is already taken on this machine).
REM Usage: double-click and KEEP THIS WINDOW OPEN.
REM         This is the FOREGROUND variant - closing the window
REM         kills the service. For a detached one use
REM         start_web_bg.bat instead.
REM ============================================================
setlocal
cd /d "%~dp0"
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"

REM --- Local port (8765 is taken by another program here) ---
set "WB_PORT=8790"

REM Pick an available Python interpreter (prefer WorkBuddy bundled, then system)
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

title WorkBuddy Checkin Web Server
echo Starting WorkBuddy checkin web server on port %WB_PORT%...
echo (Keep this window open. Press Ctrl+C to stop.)
echo.
"%PYC%" "%~dp0web_server.py"
echo.
echo Server stopped.
pause
