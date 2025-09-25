rem *********************************************************************************************
rem *********************************************************************************************
rem *********************************************************************************************

@echo off & setlocal enabledelayedexpansion 
%= above line = MUST have pc not remember variables to enviroment DO NOT REMOVE =% 


:: ________________________________________________________________________________________________________________________________________
        %= output script information to terminal for user  =% 


if %loser%==True ( goto :initilization ) else ( echo testing intro... )


echo -- aloeBrooks automated software initilization -- 
echo Last mod: Sep 15 2025
echo Created by: Allie Christensen Brooks

:: ________________________________________________________________________________________________________________________________________
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

if  %loser%==True ( goto :startBat & pause ) else ( echo "Your a winner chckn dinner, env comming in hot" & pause )

rem *********************************************************************************************
rem *********************************************************************************************
rem *********************************************************************************************



@echo off
:: Batch file to grab software dependancies:
:: -> repository is installed
:: -> && a requirements.txt is given at PATH_

:: ________________________________________________________________________________________________________________________________________

:: Ensure script runs as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (( echo Elevating privileges... & powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Normal" ) && exit /b )

@echo off
:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion

:: ________________________________________________________________________________________________________________________________________

call env_vars.txt

:: ________________________________________________________________________________________________________________________________________


set "fileName=requirements.txt"
set "filePath=%TEMP%"
set "overRideSavePath=True"

:: ________________________________________________________________________________________________________________________________________

echo ________________________________ requirements.txt auto setup ______________________________________
echo                                                                     	 Last mod: May 13 2025
echo Written by: Allie Christensen ONLY lol what a joke
echo _______________________________________________________________________________________

echo Searching for "...\%repo%*" ....





:: ________________________________________________________________________________________________________________________________________
			%= 	If venv in repo ensure checking venv dependancies 		=% 

:chkVenv
 
set "venvPath_=%PATH_%%venvName%\" 
set flag=False

:: Ensure virtual environment exists if not det sys installs
if exist %venvPath_%Scripts\activate.bat ( echo VENV FOUND ---- & set "flag=True" ) else ( echo NONE^. Freezing cw setup... & goto :startWrite ) 



:: ________________________________________________________________________________________________________________________________________

:startWrite

rem grab current date and time for file writing 
for /f "delims=" %%x in ('powershell -command "Get-Date -Format r"') do set rfcdate=%%x


:: create requirements file and write creation information 
( echo %repo% dependancies & if %flag% ==True ( echo --Venv=True ) & echo : Created on %rfcdate% ) > %filePath%%fileName% || ( echo snapples^^! & pause ) 

:: ________________________________________________________________________________________________________________________________________

:freezeDep
echo grabbing for dependacies... & echo. & echo PCKGS: & echo ---------


:: grab installed packages if venv OR Errors to grab installed packages if no venv
( pip freeze >> %filePath%%fileName% 2>nul ) || ( 
	echo pandas... alt method... & echo.
	%PYTHON_EXE% -m pip freeze >> %filePath%%fileName% || ( echo ERROR BAD & pause && exit /b )
	%PYTHON_EXE% -m pip freeze
	goto :done
	) 

pip freeze

:: ________________________________________________________________________________________________________________________________________

:done

echo ---------
echo. 
echo 		--- Done ---
echo				TXT File SAVED : ^> %filePath%%fileName%
echo 				REPO referenced: ^> %PATH_%
echo. 
echo Close? & pause

:: ________________________________________________________________________________________________________________________________________

:close
    echo --------------^> closing in %closetime% sec^! 
    echo -n | ping -n "%closetime%" 127.0.0.1 >nul 
    endlocal 
    exit
