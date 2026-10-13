@echo off
setlocal
cd /d "%~dp0"
title Minaia - Cloudflare Tunnel
where cloudflared >nul 2>&1
if errorlevel 1 (
  echo ERRO: instale cloudflared e disponibilize no PATH.
  pause
  exit /b 1
)
if not exist "%USERPROFILE%\.cloudflared\config.yml" (
  echo ERRO: config.yml ausente em %USERPROFILE%\.cloudflared
  echo Copie cloudflared-config.example.yml e preencha os dados reais do tunnel.
  pause
  exit /b 1
)
cloudflared tunnel --config "%USERPROFILE%\.cloudflared\config.yml" ingress validate
if errorlevel 1 (
  echo ERRO: configuracao invalida.
  pause
  exit /b 1
)
cloudflared tunnel --config "%USERPROFILE%\.cloudflared\config.yml" run minaia-minecraft
echo Tunnel finalizado.
pause
