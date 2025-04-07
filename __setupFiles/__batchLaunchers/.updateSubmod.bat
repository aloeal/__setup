@echo off

:: Batch file to update submodules in repot with most RECENT commit in submod repo

:: ________________________________________________________________________________________________________________________________________

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion

:: ________________________________________________________________________________________________________________________________________

:: move to top level parent dir 

cd ..\..\.. & echo -- PARENT REPO --

git submodule update --remote  || ( echo ERROR %errorlevel%: ...tried to update repo with submodule but repo has local changes that will be overwritten^. & goto :confirm) 

echo Updated submodule^!

goto :close


:: ________________________________________________________________________________________________________________________________________

:confirm

:: as user which python dir
echo Overwrite local? & set /p over="y or n: "

:: when changing path option enabled
if /i !over! == y ( git submodule update --remote  --force || ( echo -n | set /p=ERROR %errorlevel%: & IF %errorlevel% == 128 ( echo NOT IN PARENT REPO^! ) else ( echo Try again. ) & goto :close ) )

if /i !over! neq y (
    echo ummm....nah
    rem grab other errors
    if /i !over! neq n ( echo. & echo ERROR: Please input "y" or "n" & echo Please try again^. & goto :confirm )
    if /i !over! == n ( echo -n | set /p="... exiting!" && goto :close ) )


:: ________________________________________________________________________________________________________________________________________

:close

echo --------------^> closing^!
rem inform user of closing and close after number of sec delay
echo -n | ping -n 3 127.0.0.1 >nul

endlocal
exit /b 