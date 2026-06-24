@echo off

set VIVADO=C:\AMDDesignTools\2025.2\Vivado\bin\vivado.bat

pushd "%~dp0"

if %SYNTHESIS%==1 (
    echo Running synthesis...
    call %VIVADO% -nojournal -mode batch -source synthesis.tcl
)

echo Running program...
call %VIVADO% -nojournal -mode batch -source program.tcl