
rem *********************************************************************************************
rem *********************************************************************************************
rem *********************************************************************************************

@echo off & setlocal enabledelayedexpansion 
%= above line = MUST have pc not remember variables to enviroment DO NOT REMOVE =% 

:: ________________________________________________________________________________________________________________________________________
        %= output script information to terminal for user  =% 


set "lastMod=Sep 22 2025"
set "title=automated system software "

:: ________________________________________________________________________________________________________________________________________
:: ________________________________________________________________________________________________________________________________________
        %= ensure prop dir and load files needed to setup software in __setupFiles =% 

:initilization


if %loser%==True ( echo  its giving our great trimphed czar & goto :start ) else ( echo testing intro... )

rem *********************************************************************************************
        %= import funks.bat and requirements.txt and env_vars.txt =% 


rem load file with batch functions to initalize terminal operation and repo location
call :load_funks | echo ERROR loading funkies oh no!

rem run funks.bat to set repo location PATH_ and respectively python or winpython path 
call :startFunky | echo ERROR starting the funk 


call :helloSoftware %title% %lastMod%


rem *********************************************************************************************
rem *********************************************************************************************
rem *********************************************************************************************


:start
echo started...


:: ________________________________________________________________________________________________________________________________________

:run

:: user wants to debug -> enable cmd /k 
if %debug% neq 0 ( 
    echo debuggin^^! 
    %pyPATHs% %repoPATHs%%file% || ( echo ERROR DEBUG: oh lets get it & cmd /k )
)
if %debug% == 0 ( 
    echo +ultra-mode...
    %pyPATHs% %repoPATHs%%file% || ( echo oh hell nah...try again & pause & goto :exit )
)


:: ________________________________________________________________________________________________________________________________________

:load_funks
    cd . 
    echo here
    cd 
    call .\__setupFiles\_batchLaunchers\.relativeUse\funks.bat || (
        echo [ERROR] Failed to load funks.bat
        exit /b 
    )
    echo [INFO] == Reloaded funks.bat ==
    exit /b

:exit
    call :close