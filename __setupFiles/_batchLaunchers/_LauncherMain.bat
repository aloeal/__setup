@echo off & setlocal enabledelayedexpansion 
rem above line = MUST have pc not remember variables to enviroment DO NOT REMOVE
rem *********************************************************************************************
        %= output script information to terminal for user  =% 


set "lastMod=Sep 22 2025"
set "title=automated system software launcher "

rem *********************************************************************************************
rem *********************************************************************************************
rem *********************************************************************************************
        %= import funks.bat and requirements.txt and env_vars.txt =% 

:initilization

if %loser%==True ( echo  its giving our great trimphed czar & goto :start ) else ( echo testing intro... )

rem load file with batch functions to initalize terminal operation and repo location
call :load_funks | echo ERROR loading funkies oh no!

rem run funks.bat to set repo location PATH_ and respectively python or winpython path 
call :_init %file% | echo ERROR starting the funk 

call :helloSoftware %title% %lastMod%


rem *********************************************************************************************
rem *********************************************************************************************
rem *********************************************************************************************


:start
echo started... and ready? & pause 

call :runFile


:: ________________________________________________________________________________________________________________________________________

:load_funks
    cd . 
    echo here
    cd 
    for /f "delims=" %%F in ('where funks.bat') do ( call "%%F" || echo error funks & pause & exit /b) 
    exit /b

:exit
    call :close