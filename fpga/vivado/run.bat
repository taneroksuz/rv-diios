@echo off
setlocal

pushd "%~dp0"

if defined SYNTHESIS (
    if "%SYNTHESIS%"=="1" (
        echo Running synthesis...
        call vivado.bat -nojournal -mode batch -source synthesis.tcl
    )
)

echo Running program...
call vivado.bat -nojournal -mode batch -source program.tcl

popd
endlocal