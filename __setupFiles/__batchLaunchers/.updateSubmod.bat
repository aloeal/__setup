@echo off

:: Batch file to update submodules in repot with most RECENT commit in submod repo

:: ________________________________________________________________________________________________________________________________________

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion

:: ________________________________________________________________________________________________________________________________________

:: move to top level parent dir 

cd ..\..\.. 
echo ------------------------- GitHub Submodule Update -------------------------------------
echo NIST: 675^.02                                                   Last mod: April 7 2025
echo Written by: Allie Christensen
echo ---------------------------------------------------------------------------------------
echo.
echo -n | set /p="Submodule updated?       "
git submodule update --remote >nul 2>&1 || ( echo. & echo ERROR %errorlevel% & goto :confirm ) 

echo Yas^!^!

goto :close


:: ________________________________________________________________________________________________________________________________________

:confirm

echo Attempt to update repo but local changes will be overwritten^! Overwrite local? & set /p over="y or n: "

if /i !over! == y ( git submodule update --remote --force >nul 2>&1 || ( echo. & echo -n | set /p=ERROR %errorlevel%: & IF %errorlevel% == 128 ( echo NOT IN PARENT REPO^! ) else ( echo Try again. ) & goto :close ) )

if /i !over! neq y (

    rem grab other errors
    if /i !over! neq n ( echo. & echo ERROR: Please input "y" or "n" & echo Please try again^. & goto :confirm )
    if /i !over! == n ( echo -n | set /p="... exiting!" && goto :close ) )


:: ________________________________________________________________________________________________________________________________________

:close

echo  --------------^> closing^!
rem inform user of closing and close after number of sec delay
echo -n | ping -n 5 127.0.0.1 >nul

endlocal
exit /b 