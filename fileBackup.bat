@echo off
setlocal enabledelayedexpansion

::variables
set "logFile=backup_log.txt"
set "tempFile=temp_log.txt"
set "maxBackups=5"
set "lineCount=0"

goto :CheckInput

:CheckInput
if not "%2"=="" (
    echo Error: Too many parameters entered.
    exit /b
)

if "%1"=="" (
    echo No filename provided. Please enter one.
    set /p fileName=Filename: 
) else (
    set "fileName=%1"
)

:: Check if log file exists
if not exist "%logFile%" (
    echo Creating new log file...
)
goto :FileCheck



:FileCheck
echo You selected: %fileName%

:: If file doesn't exist, create and open it
if not exist "%fileName%" (
    echo File does not exist. Creating it...
    echo. > "%fileName%"
    start notepad "%fileName%"
    exit /b
)

:: Create backup file 
for %%F in ("%fileName%") do set "backupFile=%%~nF.bak"

copy "%fileName%" "!backupFile!" >nul

:: Count lines in existing log file 
if exist "%logFile%" (
    for /f "delims=" %%A in (%logFile%) do (
        set /a lineCount+=1
    )
)

:: If 5 or more log entries, remove oldest
if !lineCount! geq %maxBackups% (
    echo Log has too many entries. Removing oldest...
    set skip=1
    > "%tempFile%" (
        for /f "delims=" %%A in (%logFile%) do (
            if defined skip (
                set skip=
            ) else (
                echo %%A
            )
        )
    )
    move /y "%tempFile%" "%logFile%" >nul
)

:: Create timestamp + adding to log file
set stamp=%date% %time%

echo %stamp% Backup created: %fileName% == %backupFile% >> "%logFile%"
echo Backup created, opening orginal 
echo goodbye :3

:: Open original file
start notepad "%fileName%"
exit /b
