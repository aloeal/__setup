
@echo off & setlocal enabledelayedexpansion 
%= above line = MUST have pc not remember variables to enviroment DO NOT REMOVE =% 


:: ________________________________________________________________________________________________________________________________________
        %= output script information to terminal for user  =% 


if %loser%==True ( goto :initilization ) else ( echo testing intro... )


echo -- aloeBrooks automated system software launcher file -- 
echo Last mod: Sep 15 2025
echo Created by: Allie Christensen Brooks

:: ________________________________________________________________________________________________________________________________________
        %= ensure prop dir and load files needed to setup software in __setupFiles =% 

:initilization

echo ****************** & echo starting up... & echo ******************

cd /d "%~dp0\..\.." & call :displayCwd

if  %loser%==True ( echo loserville ) else ( echo its giving our great trimphed czar & pause )

rem *********************************************************************************************
        %= import funks.bat and requirements.txt and env_vars.txt =% 


rem load file with batch functions to initalize terminal operation and repo location
call :load_funks | echo ERROR loading funkies oh no!

rem run funks.bat to set repo location PATH_ and respectively python or winpython path 
call :startFunky

if  %loser%==True ( goto :startBat ) else ( echo "Your a winner chckn dinner, env comming in hot" & pause )

:: ________________________________________________________________________________________________________________________________________
                %= activate environment and move into working dir =% 
:actVenv

cd %PATH_%

:: ________________________________________________________________________________________________________________________________________
echo                         !repo! venv: 
echo    ^> !SETUP!
echo ________________________________________________________________________
echo.


rem Ensure virtual environment exists if not create it with local python installed 
if not exist %SETUP% ( echo ERROR: Virtual environment not found^! Ensure venvSetup.bat build venv in FSO. & pause && exit /b )

:: Activate the virtual environment
call %SETUP% || ( echo ERROR: Virtual environment activation FAIL^^! Attempt manual & cmd /k )

:: ________________________________________________________________________________________________________________________________________

:startBat

:: user wants to debug -> enable cmd /k 
if %debug% neq 0 ( 
    echo debuggin^^! 
    %pyPATHs% %repoPATHs%%file% || ( echo ERROR DEBUG: oh lets get it & cmd /k )
)
if %debug% == 0 ( 
    echo +ultra-mode...
    %pyPATHs% %repoPATHs%%file% || ( echo oh hell nah...try again & pause & goto :close )
)



:: ________________________________________________________________________________________________________________________________________



:load_var
    call %PATH_%\__setup\__setupFiles\__files\env_vars.txt
    echo "      == RELOADED env_var.txt ==" & exit /b

:close
    endlocal
    deactivate
    exit 
