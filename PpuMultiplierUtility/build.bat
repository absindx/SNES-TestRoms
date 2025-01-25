@echo off
setlocal enabledelayedexpansion
pushd %~dp0

set OutputName=PpuMultiplierUtility
set MainSource=Main
set Emulator=..\..\Mesen2\Mesen.exe
set Assembler=..\..\Asar\asar.exe
set AssembleOptions=--symbols=wla --fix-checksum=on

echo -------------------------------------------------->  build.log
echo               %date% %time: =0%>>                    build.log
echo -------------------------------------------------->> build.log

set ArgCommand=%1

rem Erase files to avoid patch mode
move /Y "%OutputName%.sfc" "%OutputName%.sfc.old" > NUL 2>&1

if "%ArgCommand%"=="" goto Assemble
if "%ArgCommand%"=="%ArgCommand:d=%" goto Assemble
	rem set DEBUG define
	set ArgCommand=%ArgCommand:d=%
	set AssembleOptions=%AssembleOptions% --define DEBUG=1

:Assemble
%Assembler% %AssembleOptions% "%MainSource%.asm" "%OutputName%.sfc" >> build.log 2>&1
set AssembleResult=%errorlevel%
type build.log

if not %AssembleResult% == 0 goto Restore

:RunEmulator
if "%ArgCommand%"=="" goto Return
	rem Force reload from commandline
	rem start %Emulator% "%OutputName%"
	start %Emulator% "%OutputName%.sfc"
	goto Return

:Restore
move /Y "%OutputName%.sfc.old" "%OutputName%.sfc" > NUL 2>&1

:Return
popd
