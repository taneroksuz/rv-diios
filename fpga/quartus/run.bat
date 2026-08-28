@echo off
setlocal

pushd "%~dp0"

if defined SYNTHESIS (
    if "%SYNTHESIS%"=="1" (
        call quartus_sh.exe -t synthesis.tcl
    )
)

tasklist /fi "imagename eq jtagd.exe" 2>nul | find /i "jtagd.exe" >nul
if not errorlevel 1 (
    taskkill /f /im jtagd.exe >nul
)

call jtagconfig.exe
call quartus_pgm.exe -m jtag -o "p;%~dp0top.sof"

popd
endlocal