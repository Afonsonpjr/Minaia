@echo off
setlocal
title Minaia - Conexao do Jogador
where cloudflared >nul 2>&1
if errorlevel 1 (
  echo ERRO: cloudflared nao encontrado. Instale antes de conectar.
  pause
  exit /b 1
)
echo Minecraft Java: localhost:25566
echo Mantenha esta janela aberta.
cloudflared access tcp --hostname mc.inkit.casa --url localhost:25566
echo Conexao encerrada.
pause
