@echo off
setlocal
cd /d "%~dp0"
title Minaia - Servidor Fabric
where java >nul 2>&1
if errorlevel 1 (
  echo ERRO: Java nao encontrado. Instale Java 25 ou superior.
  pause
  exit /b 1
)
java -version
if not exist "fabric-server-launch.jar" (
  echo ERRO: fabric-server-launch.jar ausente.
  echo Instale o Fabric Server antes de iniciar.
  pause
  exit /b 1
)
echo Iniciando Minaia...
java -Xms2G -Xmx4G -jar "fabric-server-launch.jar" nogui
echo.
echo Servidor finalizado. Consulte logs/latest.log em caso de erro.
pause
