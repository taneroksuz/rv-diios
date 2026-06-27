@echo off
setlocal

pushd "%~dp0"

if %SYNTHESIS%==1 (
    call quartus_map.exe --write_settings_files=off top.qsf
    call quartus_fit.exe --write_settings_files=off top
    call quartus_asm.exe --write_settings_files=off top
    call quartus_sta.exe top
)

tasklist /fi "imagename eq jtagd.exe" 2>nul | find /i "jtagd.exe" >nul
if not errorlevel 1 (
    taskkill /f /im jtagd.exe >nul
)

call jtagconfig.exe
call quartus_pgm.exe -m jtag -o "p;%~dp0output_files\top.sof"