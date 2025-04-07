@echo off
:: Batch file to update submodules in repot with most RECENT commit in submod repo
:: ________________________________________________________________________________________________________________________________________

:: Ensure script runs as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Elevating privileges...
    powershell -Command "Start-Process cmd.exe -Verb RunAs -WorkingDirectory %~dp0 " && exit /b ) 
:: ________________________________________________________________________________________________________________________________________

@echo off

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion
:: ________________________________________________________________________________________________________________________________________

:: move to top level parent dir 

cd ..\..\.. & echo -- PARENT REPO --

git submodule update --remote  || ( echo ERROR %errorlevel%: ...tried to update repo w/ submodule but repo has local changes that will be overwritten. & goto :confirm) 

echo Updated submodule^!
pause && exit 

:confirm

:: as user which python dir
echo Overwrite local? 
echo -n | set /p answer=" Answer (y/n): "

:: when changing path option enabled
if /i !answer! == y ( echo okeeeee & pause & git submodule update --remote  --force )

if /i !answer! neq y (
    echo -n |set /p=ummm....nah
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR: Please input "y" or "n" & echo Please try again^. & goto :confirm )
    if /i !answer! == n ( echo -n | set /p="... exiting!" & pause && exit ) )



:: _____________