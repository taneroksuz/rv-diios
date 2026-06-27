@echo off

pushd "%~dp0"

if %SYNTHESIS%==1 (
    echo Running synthesis...
    call vivado.bat -nojournal -mode batch -source synthesis.tcl
)

echo Running program...
call vivado.bat -nojournal -mode batch -source program.tcl