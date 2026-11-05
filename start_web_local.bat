@echo off
REM 本机启动脚本（在 start_web.bat 基础上加了端口设置）
REM 原因：本机 8765 端口被 WorkMami_0.1.1_win_x64.exe 占用，签到服务改用 8790
REM 用法：双击本文件即可；停止按 Ctrl+C
setlocal
cd /d "%~dp0"
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"

REM --- 本机端口（8765 已被 WorkMami 占用）---
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
