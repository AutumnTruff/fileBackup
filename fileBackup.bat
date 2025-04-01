:: ============================================
:: Student SID: 2211625
:: Module: Operating Systems (2024/25)
:: Assignment: Batch File Utility – File Backup
:: ============================================

@echo off
setlocal enabledelayedexpansion

:: === Bootloader ===
set "logFile=backup_log.txt"
set "tempFile=temp_log.txt"
set "maxBackups=5"
set "lineCount=0"

:: === Start Program ===
goto :CheckInput

:: ===========================
:: === Method: CheckInput ===
:: ===========================
:CheckInput
if not "%2"=="" (
    echo Error: Too many arguments.
    exit /b
)

if "%1"=="" (
    echo No filename provided. Please enter one.
    set /p fileName=Filename: 
) else (
    set "fileName=%1"
)

goto :FileCheck

:: ===========================
:: === Method: FileCheck ===
:: ===========================
:FileCheck
echo You selected: %fileName%

:: If file doesn't exist, create it and open it
if not exist "%fileName%" (
    echo File does not exist. Creating it...
    echo. > "%fileName%"
    start notepad "%fileName%"
    exit /b
)

:: === Backup the existing file ===
set "backupFile=%fileName%.bak"
copy "%fileName%" "!backupFile!" >nul

:: === Count existing log entries ===
if exist "%logFile%" (
    for /f "delims=" %%A in (%logFile%) do (
        set /a lineCount+=1
    )
)

:: === If 5 or more entries, delete the oldest ===
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

:: === Create timestamp for log entry only ===
set "timestamp=%date%_%time%"
set "timestamp=%timestamp:/=_%"
set "timestamp=%timestamp::=_%"
set "timestamp=%timestamp:.=%"
set "timestamp=%timestamp: =0%"

:: === Log the backup operation ===
echo !timestamp! - Original: %fileName% --- Backup: %backupFile% >> "%logFile%"

:: === Open the original file ===
start notepad "%fileName%"
exit /b
