@echo off
setlocal
chcp 65001 >nul
echo.
echo   DSH 配对码生成器（一次性，30 秒内有效）
echo   ------------------------------------------------
echo   已自动配置客户端地址：https://lty05042.github.io/dsh-mobile-web/
echo   手机无需运行本脚本；请在电脑上运行，然后用手机打开生成的深链。
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\pair.ps1" -Client "https://lty05042.github.io/dsh-mobile-web/"
if errorlevel 1 (
  echo.
  echo  运行失败：请确认 DSH 正在运行，且本文件位于项目根目录。
  pause
)
endlocal
