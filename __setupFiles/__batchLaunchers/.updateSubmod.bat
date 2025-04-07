rem @echo off
rem :: Batch file to update submodules in repot with most RECENT commit in submod repo
rem :: ________________________________________________________________________________________________________________________________________

rem :: Ensure script runs as administrator
rem net session >nul 2>&1
rem if %errorlevel% neq 0 (
rem     echo Elevating privileges...
rem     powershell -Command "Start-Process cmd.exe -Verb RunAs -WorkingDirectory %~dp0 " && exit /b ) 
:: ________________________________________________________________________________________________________________________________________

@echo off

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion
:: ________________________________________________________________________________________________________________________________________

:: move to top level parent dir 

cd ..\..\.. & echo -- PARENT REPO --

git submodule update --remote  || ( echo ERROR %errorlevel%: ...tried to update repo w/ submodule but repo has local changes that will be overwritten. & goto :confirm) 

echo Updated submodule^!

goto :close


:confirm

:: as user which python dir
echo Overwrite local? 
echo -n | set /p answer=" Answer (y/n): "

:: when changing path option enabled
if /i !answer! == y ( echo okeeeee & git submodule update --remote  --force || ( echo ERROR %errorlevel%: TRY again. & goto :close)  )

if /i !answer! neq y (
    echo -n |set /p=ummm....nah
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR: Please input "y" or "n" & echo Please try again^. & goto :confirm )
    if /i !answer! == n ( echo -n | set /p="... exiting!" & pause && goto :close ) )



:: _____________

:close

echo --------------^> closing^!
rem inform user of closing and close after number of sec delay
echo -n | ping -n 10 127.0.0.1 >nul

endlocal
exit