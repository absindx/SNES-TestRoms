@echo off
setlocal enabledelayedexpansion
pushd %~dp0

set OutputName=SA1RamProtectionTest
set MainSource=Main
set Emulator=..\..\Mesen2\Mesen.exe
set Assembler=..\..\Asar\asar.exe
set AssembleOptions=--symbols=wla --fix-checksum=on
set AssembleOptions_NoSave=--define NOSRAM
rem                 --verbose

echo -------------------------------------------------->  build.log
echo               %date% %time: =0%>>                    build.log
echo -------------------------------------------------->> build.log

rem Erase files to avoid patch mode
move /Y "%OutputName%.sfc" "%OutputName%.sfc.old" > NUL 2>&1

:Assemble
%Assembler% %AssembleOptions% "%MainSource%.asm" "%OutputName%.sfc" >> build.log 2>&1
set AssembleResult=%errorlevel%
type build.log

if not %AssembleResult% == 0 goto Restore

:AssembleNoSRAM
%Assembler% %AssembleOptions% %AssembleOptions_NoSave% "%MainSource%.asm" "%OutputName%(NO SRAM).sfc" >> NUL 2>&1

if not "%1"=="" (
	rem Force reload from commandline
	start %Emulator% "%OutputName%.sfc"
)

goto Return

:Restore
move /Y "%OutputName%.sfc.old" "%OutputName%.sfc" > NUL 2>&1

:Return
popd
