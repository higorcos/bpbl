@echo off
setlocal

:: Defina o nome da etiqueta (label) do seu pendrive
set "LABEL_USB=BACKUP CA"

:: Loop para procurar a unidade com esse label
for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    vol %%D: 2>nul | find /I "%LABEL_USB%" >nul
    if not errorlevel 1 (
        set "USB_DRIVE=%%D:"
        goto :encontrado
    )
)

echo Pendrive com etiqueta "%LABEL_USB%" não foi encontrado. Backup cancelado.
goto :fim

:encontrado
echo Pendrive encontrado em %USB_DRIVE%. Iniciando backup...

:: Realiza o backup
xcopy "C:\Users\higor\Documents\testes" "%USB_DRIVE%\Backupteste" /E /H /Y

echo Backup concluído com sucesso.

:: Acessa o repositório
cd /d "C:\Users\higor\Documents\testes"

git add .

:: Gera data e hora para o commit
for /f %%i in ('powershell -command "Get-Date -Format \"dd-MM-yyyy_HH-mm-ss\""') do set COMMIT_DATE=%%i

git commit -m "%COMMIT_DATE%"
git push

:fim
echo Pressione qualquer tecla para sair...
pause >nul
endlocal
