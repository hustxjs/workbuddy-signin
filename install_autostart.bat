@echo off
setlocal
REM Add WorkBuddy checkin web server to Windows startup (per-user, no admin needed).
REM Creates a hidden launcher in the Startup folder; the server starts silently at logon.

set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
REM Local build points at start_web_local.bat (port 8790). The upstream
REM start_web.bat uses the default port 8765, which is already taken on
REM this machine, so the autostart entry would fail to bind.
if exist "%~dp0start_web_local.bat" (
    set "TARGET=%~dp0start_web_local.bat"
) else (
    set "TARGET=%~dp0start_web.bat"
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
echo Done. Open the page on your phone (see URL printed by start_web.bat).
pause
