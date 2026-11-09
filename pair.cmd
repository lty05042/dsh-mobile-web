@echo off
setlocal
title DSH pairing helper
chcp 65001 >nul
echo.
echo   DSH pairing helper - generates a one-time pairing link (valid 30s)
echo   ------------------------------------------------------------------
echo   Client page: https://lty05042.github.io/dsh-mobile-web/
echo   Run this on the PC that is running DSH, then open the link on your phone.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\pair.ps1" -Client "https://lty05042.github.io/dsh-mobile-web/"
if errorlevel 1 (
  echo.
  echo Failed: make sure DSH is running, and this file is in the project root.
  pause
)
endlocal
