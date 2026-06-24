@echo off
setlocal

set QUARTUS=C:\altera_lite\25.1std\quartus\bin64\quartus
set JTAGCONFIG=C:\altera_lite\25.1std\quartus\bin64\jtagconfig.exe

pushd "%~dp0"

if %SYNTHESIS%==1 (
    call %QUARTUS%_map --write_settings_files=off top.qsf
    call %QUARTUS%_fit --write_settings_files=off top
    call %QUARTUS%_asm --write_settings_files=off top
    call %QUARTUS%_sta top
)

tasklist /fi "imagename eq jtagd.exe" 2>nul | find /i "jtagd.exe" >nul
if not errorlevel 1 (
    taskkill /f /im jtagd.exe >nul
)

call %JTAGCONFIG%
call %QUARTUS%_pgm -m jtag -o "p;%~dp0output_files\top.sof"