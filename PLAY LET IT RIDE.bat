@echo off
rem Double-click to play LET IT RIDE (no editor needed).
rem It runs the game with the Godot engine in your Downloads folder.
set GODOT=%USERPROFILE%\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe
if not exist "%GODOT%" (
  echo Could not find Godot at:
  echo   %GODOT%
  echo Edit this file and set GODOT to where Godot_v4.7.2-stable_win64.exe is.
  pause
  exit /b 1
)
start "" "%GODOT%" --path "%~dp0"
