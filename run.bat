@echo off
setlocal enabledelayedexpansion

:: Load environment variables from .env file
set ENV_FILE=.env
for /f "tokens=1,2 delims==" %%a in ('findstr /r /c:"^.*=.*" %ENV_FILE%') do (
    set %%a=%%b
)

:: Set variables from .env file
set DB_NAME=%DB_NAME%
set MYSQL_HOST=%MYSQL_HOST%
set MYSQL_USER=%MYSQL_USER%
set MYSQL_PASS=%MYSQL_PASS%
set DOWNLOADS_DIR=%DOWNLOADS_DIR%
set MYSQL_BIN_DIR=.

:: Initialize a counter
set count=0

:: List all .sql files in the Downloads folder
echo Available SQL files:
for %%f in ("%DOWNLOADS_DIR%\*.sql") do (
    set /a count+=1
    echo !count! - %%~nxf
)

:: Check if there are no SQL files
if !count! equ 0 (
    echo No SQL files found in the Downloads folder.
    exit /b
)

:: Prompt user to choose a file
set /p choice="Enter the number of the SQL file to dump: "

:: Validate input
if !choice! leq 0 if !choice! gtr !count! (
    echo Invalid choice. Exiting.
    exit /b
)

:: Get the selected SQL file
set file=""
set idx=0

for %%f in ("%DOWNLOADS_DIR%\*.sql") do (
    set /a idx+=1
    if !idx! equ !choice! (
        set file=%%f
    )
)

:: Remove the existing database
if "%MYSQL_PASS%"=="" (
    %MYSQL_BIN_DIR%\mysql.exe -h %MYSQL_HOST% -u %MYSQL_USER% -e "DROP DATABASE IF EXISTS %DB_NAME%;"
) else (
    %MYSQL_BIN_DIR%\mysql.exe -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% -e "DROP DATABASE IF EXISTS %DB_NAME%;"
)

:: Create the new database
if "%MYSQL_PASS%"=="" (
    %MYSQL_BIN_DIR%\mysql.exe -h %MYSQL_HOST% -u %MYSQL_USER% -e "CREATE DATABASE %DB_NAME%;"
) else (
    %MYSQL_BIN_DIR%\mysql.exe -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% -e "CREATE DATABASE %DB_NAME%;"
)

:: Install the dump into the new database
if "%MYSQL_PASS%"=="" (
    %MYSQL_BIN_DIR%\mysql.exe -h %MYSQL_HOST% -u %MYSQL_USER% %DB_NAME% < "!file!"
) else (
    %MYSQL_BIN_DIR%\mysql.exe -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "!file!"
)

echo Database '%DB_NAME%' has been recreated and the dump from '!file!' has been installed.

:: Pause at the end
pause
