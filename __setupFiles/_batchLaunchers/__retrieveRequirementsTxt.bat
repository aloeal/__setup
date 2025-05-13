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

:: path to dirs (do not change)
set "repo=FSOTerminal"
set "venvName=__fsoVenv" 

set "fileName=requirements.txt"
set "filePath=%TEMP%"
set "overRideSavePath=True"

:: ________________________________________________________________________________________________________________________________________

echo ________________________________ requirements.txt auto setup ______________________________________
echo                                                                     	 Last mod: May 13 2025
echo Written by: Allie Christensen ONLY lol what a joke
echo _______________________________________________________________________________________

echo Searching for "...\%repo%*" ....



:: potential repository paths
set repoPATHs="C:\OTTRepos" "C:\Users\fcomb\OTTRepos" "C:\Users\anc32\GitItUp" "C:\Users\fcomb\GitHub" "C:\GitHub"

 

set "repoNames=%repo% %repo%-local %repo%-main"
set flagA=False 
 
:: Loop through each path in repoPATHs
for %%P in (%repoPATHs%) do (
    set "currentPath=%%~P\"
    for %%Q in (!repoNames!) do (
        set "currentRepo=%%~Q\" 

 
        if exist "!currentPath!!currentRepo!" (

            set flagA=True
            set "PATH_=!currentPath!!currentRepo!"
            rem echo -n | set /p="!currentPath!!currentRepo!" 
	    set "repo=!currentRepo!"
	    goto :repoFound 


        ) else ( rem echo -n |set /p="...!currentPath!!currentRepo!...x"  
		) 
   )
)

 

if %flagA% == False ( echo Initializing ERROR: Repo not found & pause && exit /b )

:repoFound
echo. & echo    -^> REPO found : !PATH_! & echo. 

:: move to repo path as default to save requirements file to else save to desktop of user ( TEMP avaliable SYS wide on all PCS )
if %overRideSavePath% == False ( set "filePath=%PATH_%" & echo doo da... & echo     -^> NORM: !filePath! ) 

rem move into Downloads dir for override 
if %overRideSavePath% == True ( 
	cd !filePath!
	cd ..
	cd ..
	cd ..
	cd Downloads 
	set "filePath=!cd!\"
	
	echo    -^> OVERride MODE: !filePath!
	) 

:: ___________________________________________________________________________________________________
			%= 	Find python insall (to use pip freeze) 		=% 

echo Searching for %pyType% %pyType% ...\python.exe ...

:: potential python paths
set pyPATHs="C:\Program Files\WPy64-3940" "C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64" "C:\WPy64-3940\python-3.9.4.amd64"
set flagB=False


:: Loop through each path in repoPATHs
for %%P in (%pyPATHs%) do (
    set "currentPath=%%~P\"

    if exist "!currentPath!python.exe" (
        set flagB=True 

        set "PYTHON_EXE=!currentPath!python.exe"
        goto :pythonFound

    ) else ( rem echo -n |set /p="... !currentPath!python.exe...x"
 ) )
if %flagB% == False ( echo Python not found. Install required -^> & goto :decompressExe )

:pythonFound
echo. 
echo    -^> PYTHON found : !PYTHON_EXE! & echo. 

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
