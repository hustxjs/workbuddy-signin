@echo off
setlocal
REM Add WorkBuddy checkin web server to Windows startup (per-user, no admin needed).
REM Creates a hidden launcher in the Startup folder; the server starts silently at logon.

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
REM Local build: only start_web_bg.bat ships here. It sets port 8790 and runs
REM detached, so the hidden Startup launcher works and later closing a console
REM window cannot kill the service.
set "TARGET=%~dp0start_web_bg.bat"
if not exist "%TARGET%" (
    echo [ERROR] start_web_bg.bat not found next to this script.
    pause
    exit /b 1
)
set "VBS=%STARTUP%\WorkBuddyCheckinWeb.vbs"

> "%VBS%" echo Set s = CreateObject("WScript.Shell")
>> "%VBS%" echo s.Run "cmd /c ""%TARGET%""", 0, False

echo [OK] Startup entry created:
echo      %VBS%
echo.
echo The web server will now auto-start (hidden) every time you log in.
echo To cancel: just delete that .vbs file.
echo.
echo Starting it right now (hidden)...
start "" wscript.exe "%VBS%"
echo Done. Open http://127.0.0.1:8790 (see start_web_bg.bat for details).
pause
