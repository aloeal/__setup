@echo off

:: -- NIST OchoBays Diode Controller Software --  


:: This bat file launches eBUS software for camera/galvo control
:: - @ECHO lines do not print to console, only use rem within loops and :: outside loops for comments

:: NEW Setup: 
:: change PATH_ on line 15 in "" to path where >\FSOTerminal-main\camera_control\cameraprocess is located on PC getting eBUS
:: change PATH_PYTHON on line 20 in "" to path where python executable (python.exe) is located on PC 
:: ________________________________________________________________________________________________________________________________________

:: so pc wont remember variables to enviroment DO NOT REMOVE below line
setlocal enabledelayedexpansion



:: ________________________________________________________________________________________________________________________________________

call env_vars.txt

:: ________________________________________________________________________________________________________________________________________


:: potential repository paths

echo Searching for "...\!repo!*" .... 


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
            echo -n |set /p="echo !currentPath!!currentRepo!!dir!\"

            goto :repoFound 


        ) else (
            rem echo -n |set /p="...!currentPath!!currentRepo!...x"  
        )
    )
)



if %flagA% == False ( echo Initializing ERROR: Repo not found. & pause & exit /b )

:repoFound
echo. & echo    -^> REPO found : !PATH_! & echo. 
 


:: ________________________________________________________________________________________________________________________________________


set flagB=False
 
:: potential python paths
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

echo ------------- NIST OchoBays Diode Controller Software ------------------  
echo NIST: 675.02                                     Last mod: july 7 2025
echo                                                    Allie Christensen                                                          
echo ------------------------------------------------------------------------
echo.
echo.


:: ________________________________________________________________________________________________________________________________________
                %= setup paths needed for installations =% 
:startFSO

:: dynamic path DO NOT CHANGE below
set "SETUP=%PATH_%%venvName%\Scripts\activate.bat" 
set "WORK_DIR=%PATH_%sysCode\camera_control\cameraprocess\"

cd %PATH_%

:: ________________________________________________________________________________________________________________________________________
echo                         !repo! venv: 
echo    ^> !SETUP!
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


:: ________________________________________________________________________________________________________________________________________

:startBat

:: user wants to debug -> enable cmd /k 
if %debug% neq 0 ( 
    echo debuggin^^! 
    python %WORK_DIR%%file% || ( echo ERROR DEBUG: oh lets get it & cmd /k )
)
if %debug% == 0 ( 
    echo +ultra-mode...
    python %WORK_DIR%%file% || ( echo oh hell nah...try again & pause & exit )
)



:: ________________________________________________________________________________________________________________________________________

endlocal
deactivate

