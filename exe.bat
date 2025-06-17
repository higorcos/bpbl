@echo off
setlocal

:: ================================
:: CONFIGURAÇÃO INICIAL
:: ================================
set "LABEL_USB=BACKUP CA"
set "BACKUP_SRC=C:\Users\higor\Documents\testes"
set "BACKUP_DST=Backupteste"

echo ========================================
echo  INICIANDO SCRIPT DE BACKUP E GIT PUSH
echo ========================================
echo.

:: ================================
:: LOCALIZANDO PENDRIVE
:: ================================
echo Procurando pendrive com etiqueta "%LABEL_USB%"...

for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    vol %%D: 2>nul | find /I "%LABEL_USB%" >nul
    if not errorlevel 1 (
        set "USB_DRIVE=%%D:"
        goto :encontrado
    )
)

echo [ERRO] Pendrive com etiqueta "%LABEL_USB%" não foi encontrado.
goto :fim

:encontrado
echo [OK] Pendrive encontrado na unidade %USB_DRIVE%.
echo.

:: ================================
:: REALIZANDO BACKUP
:: ================================
echo Iniciando backup de arquivos...
xcopy "%BACKUP_SRC%" "%USB_DRIVE%\%BACKUP_DST%" /E /H /Y >nul

if %errorlevel% equ 0 (
    echo [OK] Backup concluído com sucesso.
) else (
    echo [ERRO] Falha durante o backup.
)
echo.

:: ================================
:: PROCESSO GIT
:: ================================
echo Iniciando processo Git...
cd /d "%BACKUP_SRC%"

git add .

:: Gera data e hora para o commit
for /f %%i in ('powershell -command "Get-Date -Format \"dd-MM-yyyy_HH-mm-ss\""') do set COMMIT_DATE=%%i

git commit -m "%COMMIT_DATE%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Commit criado com a mensagem: "%COMMIT_DATE%"
) else (
    echo [AVISO] Nenhuma alteração para commit ou erro ao commitar.
)

git push >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Push realizado com sucesso.
) else (
    echo [ERRO] Falha ao executar o push. Verifique se o repositório remoto está configurado.
)
echo.

:: ================================
:: FINALIZAÇÃO
:: ================================
:fim
echo ========================================
echo  PROCESSO FINALIZADO
echo ========================================
echo.
echo Pressione qualquer tecla para sair...
pause >nul
endlocal
