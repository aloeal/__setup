@echo off

:: -- NIST Free Space Optics Terminal Software --  


:: This bat file launches eBUS software for camera/galvo control
:: - @ECHO lines do not print to console, only use rem within loops and :: outside loops for comments

:: NEW Setup: 
:: change PATH_ on line 15 in "" to path where >\FSOTerminal-main\camera_control\cameraprocess is located on PC getting eBUS
:: change PATH_PYTHON on line 20 in "" to path where python executable (python.exe) is located on PC 
:: ________________________________________________________________________________________________________________________________________

:: so pc wont remember variables to enviroment DO NOT REMOVE below line
setlocal enabledelayedexpansion
set "repo=FSOTerminal"
set "venvName=__fsoVenv"


:: ________________________________________________________________________________________________________________________________________
                %= USER may have to change below! =%
echo Searching for "...\!repo!*" .... 

:: ________________________________________________________________________________________________________________________________________

:: potential repository paths
set repoPATHs="C:\OTTRepos" "C:\Users\fcomb\OTTRepos" "C:\Users\anc32\GitItUp" "C:\Users\fcomb\GitHub"
 

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
            echo -n |set /p="echo !currentPath!!currentRepo!__setup\"

            goto :repoFound 


        ) else (
            echo -n |set /p="...!currentPath!!currentRepo!...x"  
        )
    )
)



if %flagA% == False ( echo Initializing ERROR: Repo not found. & pause & exit /b )

:repoFound
echo. & echo    -^> REPO found : !PATH_! & echo. 
 


:: ________________________________________________________________________________________________________________________________________


set flagB=False
 
:: potential python paths
set pyPATHs="C:\Program Files\WPy64-3940" "C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64" "C:\WPy64-3940\python-3.9.4.amd64"
echo Searching for %pyType% %pyType% ...\python.exe ...

:: Loop through each path in repoPATHs
for %%P in (%pyPATHs%) do (
    set "currentPath=%%~P\"

    if exist "!currentPath!python.exe" (
        set flagB=True 

        set "PATH_PYTHON=!currentPath!"
        set "PYTHON_EXE=!currentPath!python.exe"

        goto :pythonFound

    ) else (
         rem echo -n |set /p="... !currentPath!python.exe...x"

    )
)

if %flagB% == False ( echo Python not found. Install required -^> & goto :decompressExe )

:pythonFound
echo. 
echo    -^> PYTHON found : !PATH_PYTHON! 

:: ________________________________________________________________________________________________________________________________________

set debug=0

:: ________________________________________________________________________________________________________________________________________

echo --------------- Free Space Optics Terminal Software --------------------  
echo NIST: 675.02                                     Last mod: May 7 2025
echo                                                    Allie Christensen                                                          
echo ------------------------------------------------------------------------
echo ________________________________________________________________________
echo.
echo.
:: ________________________________________________________________________________________________________________________________________
            %= skip to fso launch if no debug =%
:askDebug

if debug == 0 ( goto :startFSO )
echo Debug Setup? & set /p answer="Answer (y/n)"

:: when cmd option enabled
if !answer! == y ( echo DEBUG MODE: Setting up cmd prompt... & set debug=1 )

if !answer! neq y (
    echo -n |set /p="meow no^! "
    rem grab other errors
    if !answer! neq n ( echo ERROR askPy: Please input "y" or "n" & goto :askDebug ) 
    
    rem when cmds disabled
    set debug=0
    echo ... meow^! & echo -n | set /p="NORMAL MODE:" 
    )

:: ________________________________________________________________________________________________________________________________________
                %= setup paths needed for installations =% 
:startFSO

:: dynamic path DO NOT CHANGE below
set "SETUP=%PATH_%%venvName%\Scripts\activate.bat" 
set "WORK_DIR=%PATH_%camera_control\cameraprocess\"

cd %PATH_%

:: ________________________________________________________________________________________________________________________________________
echo                         FSO venv: !SETUP!
echo ________________________________________________________________________
echo.
:: ________________________________________________________________________________________________________________________________________
                %= activate environment and move into working dir =% 
:actVenv

echo Calling... !SETUP!

:: Ensure virtual environment exists if not create it with local python installed 
if not exist %SETUP% ( echo ERROR: Virtual environment not found^! Ensure venvSetup.bat build venv in FSO. & pause && exit /b )

:: Activate the virtual environment
call %SETUP% || ( echo ERROR: Virtual environment activation FAIL^^! Attempt manual & cmd /k )

:: ...Change working directory -> where python will work from
cd !WORK_DIR!
echo moved to 
cd

:: ________________________________________________________________________________________________________________________________________

:startBat

:: user wants to debug -> enable cmd /k 
if %debug% neq 0 ( 
    echo debuggin^^! 
    python %WORK_DIR%camera_processor_V2.py || ( echo oh lets get it & cmd /k )
)
if %debug% == 0 ( 
    echo mode & pause 
    python %WORK_DIR%camera_processor_V2.py || ( echo oh hell nah & pause & exit )
)



:: ________________________________________________________________________________________________________________________________________

endlocal
deactivate

