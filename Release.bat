@echo off
setlocal enabledelayedexpansion
pushd %~dp0

set ReleaseDir=SnesTestRoms

rem NOTE: Folders with spaces cannot be copied correctly.

rem Clear release directory
mkdir "%ReleaseDir%"	> NUL 2>&1

for /F %%i in ('dir /b /w "%ReleaseDir%\*"') do (
	del   /s /q "%ReleaseDir%\%%i"	> NUL 2>&1
	rmdir /s /q "%ReleaseDir%\%%i"	> NUL 2>&1
)

rem Copy files (*.sfc, *.sym)
for /F %%d in ('dir /A:d /b /w') do (
	call :DirCopy "%%d" "sfc"
	call :DirCopy "%%d" "sym"
)

rem Show artifacts
dir /b /w "%ReleaseDir%"

:Return
popd
exit /b


rem --------------------------------------------------
:DirCopy

if "%~1"=="%ReleaseDir%"	goto DirCopy_Return
if "%~1"==".git"		goto DirCopy_Return

for %%f in ("%~1"\*.%~2) do (
	mkdir "%ReleaseDir%\%~1"	> NUL 2>&1
	copy "%%f" "%ReleaseDir%\%~1\"	> NUL 2>&1
)

:DirCopy_Return
exit /b
