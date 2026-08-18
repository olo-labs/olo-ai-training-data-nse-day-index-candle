@echo off
setlocal EnableExtensions
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0download_index_data.ps1" %*
exit /b %ERRORLEVEL%

